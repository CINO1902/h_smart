import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/provider/chatProvider.dart';
import 'states.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

// Replace your StreamController with:
  final BehaviorSubject<List<Map<String, dynamic>>> _messageSubject =
      BehaviorSubject<List<Map<String, dynamic>>>();

// Then expose the stream as:
  Stream<List<Map<String, dynamic>>> get messageStream =>
      _messageSubject.stream;

  // Stream controllers for messages and conversations.
  final StreamController<List<Map<String, dynamic>>> _messageStreamController =
      StreamController.broadcast();

  final StreamController<List<Map<String, dynamic>>>
      _conversationStreamController = StreamController.broadcast();

  Stream<List<Map<String, dynamic>>> get conversationStream =>
      _conversationStreamController.stream;

  /// Getter for the database instance. Initializes the database if needed.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) {
        print("Database opened successfully");
        // Emit initial empty list if needed:
        // _notifyConversations();
      },
    );
    return db;
  }

  /// Create the 'messages' and 'conversation' tables.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mongooseId TEXT,
        convoId Text,
        conversationId TEXT,
        sender TEXT,
        recipient TEXT,
        content TEXT,
        timestamp TEXT,
        isSent INTEGER,
        isRead INTEGER
      )
    ''');

    await db.execute('''
    CREATE TABLE conversation(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      conversationId TEXT UNIQUE,
      participants TEXT,
      lastMessage TEXT,
      createdAt TEXT,
      updatedAt TEXT
)
    ''');
  }

  /// ---------------------
  /// Conversation Methods
  /// ---------------------

  Future<void> initializeConversations() async {
    await _notifyConversations();
  }

  Future<void> initializeMessage() async {
    await _notifyListeners();
  }

  Future<bool> hasLocalMessages(String conversationId) async {
    final messages = await getMessages(conversationId);
    print('messages from database $messages');
    return messages.isNotEmpty;
  }

  /// Retrieve all messages for a conversation from the backend and store them locally.
  Future<void> getAllMessage(String conversationId, WidgetRef ref) async {
    try {
      await ref.read(chatProviderController).getallMessages(conversationId);
      if (ref.read(chatProviderController).getChatResult.state ==
          GetChatResultState.isData) {
        final List<dynamic> newMessages =
            ref.read(chatProviderController).getChatResult.response;
        for (var msg in newMessages) {
          print(newMessages[0]);
          // Insert each new message into the database.
          await insertMessage({
            'mongooseId': msg['_id'],
            'conversationId': conversationId,
            'sender': msg['sender'],
            'recipient': msg['recipient'],
            'content': msg['content'],
            'timestamp': msg['createdAt'],
            'isSent': 1,
            'isRead': msg['isRead']
          });
        }
        // Save the new sync time after a successful sync.
        await saveSyncTime(conversationId, DateTime.now());
      } else {
        print(
            'Incremental sync failed: ${ref.read(chatProviderController).getChatResult.state}');
      }
    } catch (e) {
      print('Error during incremental sync: $e');
    }
  }

  /// Perform an incremental sync by fetching messages from the backend that are newer than the last message.
  Future<void> incrementalSync(String conversationId, WidgetRef ref) async {
    final messages = await getMessages(conversationId);
    if (messages.isEmpty) {
      print("No local messages found, consider doing a full sync.");
      return;
    }
    final lastMessageTimestamp = messages.last['timestamp'];
    try {
      await ref
          .read(chatProviderController)
          .syncMessage(conversationId, lastMessageTimestamp);
      if (ref.read(chatProviderController).syncLastChatResult.state ==
          SyncLastChatResultStates.isData) {
        final List<dynamic> newMessages =
            ref.read(chatProviderController).syncLastChatResult.response;
        for (var msg in newMessages) {
          print('this is meant to be $msg');
          // Insert each new message into the database.
          await insertMessage({
            'mongooseId': msg['_id'],
            'conversationId': conversationId,
            'sender': msg['sender'],
            'recipient': msg['recipient'],
            'content': msg['content'],
            'timestamp': msg['createdAt'],
            'isSent': 1, // Mark as confirmed from backend.
            'isRead': msg['isRead']
          });
        }
        // ref.read(chatProviderController).resetSync();
        // Save the new sync time after a successful sync.
        await saveSyncTime(conversationId, DateTime.now());
      } else {
        print(
            'Incremental sync failed: ${ref.read(chatProviderController).syncLastChatResult.state}');
      }
    } catch (e) {
      print('Error during incremental sync: $e');
    }
  }

  Future<int> upsertMessage(
      {int? id,
      Map<String, dynamic>? message,
      int? isSent,
      dynamic timestamp,
      dynamic mongooseId,
      dynamic conversation,
      int? isRead}) async {
    print('this is meant to be $id');
    final db = await database;

    if (id == null) {
      // No id provided: Insert new message.
      if (message == null) {
        throw ArgumentError('Message map is required for insertion.');
      }

      final existing = await db
          .query('messages', where: 'mongooseId = ?', whereArgs: [mongooseId]);
      if (existing.isNotEmpty) {
        // Record exists, update with optional fields if provided.
        Map<String, dynamic> updateData = {};
        if (isSent != null) updateData['isSent'] = isSent;
        if (timestamp != null) updateData['timestamp'] = timestamp;
        if (mongooseId != null) updateData['mongooseId'] = mongooseId;
        if (conversation != null) updateData['conversationId'] = conversation;
        if (isRead != null) updateData['isRead'] = isRead;

        // Only update if there's something to update.
        if (updateData.isNotEmpty) {
          await db.update(
            'messages',
            updateData,
            where: 'mongooseId = ?',
            whereArgs: [mongooseId],
          );
        }
        await _notifyListeners();
        return 0;
      } else {
        int newId = await db.insert('messages', message);
        await _notifyListeners();
        return newId;
      }
    } else {
      // An id is provided: Check if the record exists.
      final existing =
          await db.query('messages', where: 'id = ?', whereArgs: [id]);

      if (existing.isNotEmpty) {
        // Record exists, update with optional fields if provided.
        Map<String, dynamic> updateData = {};
        if (isSent != null) updateData['isSent'] = isSent;
        if (timestamp != null) updateData['timestamp'] = timestamp;
        if (mongooseId != null) updateData['mongooseId'] = mongooseId;
        if (conversation != null) updateData['conversationId'] = conversation;
        if (isRead != null) updateData['isRead'] = isRead;

        // Only update if there's something to update.
        if (updateData.isNotEmpty) {
          await db.update(
            'messages',
            updateData,
            where: 'id = ?',
            whereArgs: [id],
          );
        }
        await _notifyListeners();
        return id;
      } else {
        // id was provided but record doesn't exist: Insert new message.
        if (message == null) {
          throw ArgumentError(
              'Message map is required for insertion when record does not exist.');
        }
        final existing = await db.query('messages',
            where: 'mongooseId = ?', whereArgs: [mongooseId]);
        if (existing.isNotEmpty) {
          // Record exists, update with optional fields if provided.
          Map<String, dynamic> updateData = {};
          if (isSent != null) updateData['isSent'] = isSent;
          if (timestamp != null) updateData['timestamp'] = timestamp;
          if (mongooseId != null) updateData['mongooseId'] = mongooseId;
          if (conversation != null) updateData['conversationId'] = conversation;
          if (isRead != null) updateData['isRead'] = isRead;

          // Only update if there's something to update.
          if (updateData.isNotEmpty) {
            await db.update(
              'messages',
              updateData,
              where: 'mongooseId = ?',
              whereArgs: [mongooseId],
            );
          }
          await _notifyListeners();
          return id;
        } else {
          int newId = await db.insert('messages', message);
          await _notifyListeners();
          return newId;
        }
      }
    }
  }

  /// Retrieve all conversations ordered by updatedAt descending.
  Future<List<Map<String, dynamic>>> getConversations() async {
    final db = await database;
    return await db.query('conversation', orderBy: 'updatedAt DESC');
  }

  /// Notify listeners of changes in the conversation table.
  Future<void> _notifyConversations() async {
    final db = await database;
    List<Map<String, dynamic>> convos =
        await db.query('conversation', orderBy: 'updatedAt DESC');
    _conversationStreamController.add(convos);
  }

  /// Delete a conversation from the conversation table and notify listeners.
  Future<int> deleteConversationEntry(String conversationId) async {
    final db = await database;
    int result = await db.delete('conversation',
        where: 'conversationId = ?', whereArgs: [conversationId]);
    await _notifyConversations();
    return result;
  }

  Future<int> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    print('this is meant to be $message');
    int id = await db.insert('messages', message);
    await _notifyListeners();
    return id;
  }

  Future<int> insertOrUpdateConversation(Map<String, dynamic> conversation,
      [int? id]) async {
    final db = await database;

    // Use conversation['_id'] as the unique conversation identifier.
    final convId = conversation['_id'];

    // Convert participants array and lastMessage to JSON strings if present.
    String participantsString = conversation['participants'] != null
        ? jsonEncode(conversation['participants'])
        : '';
    String lastMessageString = conversation['lastMessage'] != null
        ? jsonEncode(conversation['lastMessage'])
        : '';

    // Prepare the data to match your SQLite schema.
    Map<String, dynamic> conversationData = {};
    if (id != null) {
      // final insertedId = id.split('_')[0];
      conversationData = {
        'id': id,
        'conversationId': convId,
        'participants': participantsString,
        'lastMessage': lastMessageString,
        'createdAt': conversation['createdAt'],
        'updatedAt': conversation['updatedAt'],
      };
    } else {
      conversationData = {
        'conversationId': convId,
        'participants': participantsString,
        'lastMessage': lastMessageString,
        'createdAt': conversation['createdAt'],
        'updatedAt': conversation['updatedAt'],
      };
    }
    print('object convo $conversationData');

    if (id != null) {
      // final insertedId = id.split('_')[0];
      // id was passed. Check if a conversation exists with that local id.
      final List<Map<String, dynamic>> existingById = await db.query(
        'conversation',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (existingById.isNotEmpty) {
        // Conversation exists, update it.
        await db.update(
          'conversation',
          conversationData,
          where: 'id = ?',
          whereArgs: [id],
        );

        await _notifyConversations();
        return id;
      } else {
        if (convId != null) {
          // Check if a conversation with this conversationId already exists.
          final List<Map<String, dynamic>> existingByConvId = await db.query(
            'conversation',
            where: 'conversationId = ?',
            whereArgs: [convId],
          );
          if (existingByConvId.isNotEmpty) {
            // Found an existing conversation; update it.
            int localId = existingByConvId.first['id'];
            await db.update(
              'conversation',
              conversationData,
              where: 'id = ?',
              whereArgs: [localId],
            );
            return localId;
          } else {
            // No conversation with this id exists, so insert a new one.
            int newId = await db.insert('conversation', conversationData);
            await _notifyConversations();
            return newId;
          }
        } else {
          // No conversation with this id exists, so insert a new one.
          int newId = await db.insert('conversation', conversationData);
          await _notifyConversations();
          return newId;
        }
      }
    } else {
      // id was not passed.
      // Check if a conversation with this conversationId already exists.
      final List<Map<String, dynamic>> existingByConvId = await db.query(
        'conversation',
        where: 'conversationId = ?',
        whereArgs: [convId],
      );

      if (existingByConvId.isNotEmpty) {
        // Found an existing conversation; update it.
        int localId = existingByConvId.first['id'];
        await db.update(
          'conversation',
          conversationData,
          where: 'id = ?',
          whereArgs: [localId],
        );
        await _notifyConversations();
        return localId;
      } else {
        if (convId != null) {
          // Check if a conversation with this conversationId already exists.
          final List<Map<String, dynamic>> existingByConvId = await db.query(
            'conversation',
            where: 'conversationId = ?',
            whereArgs: [convId],
          );
          if (existingByConvId.isNotEmpty) {
            // Found an existing conversation; update it.
            int localId = existingByConvId.first['id'];
            await db.update(
              'conversation',
              conversationData,
              where: 'id = ?',
              whereArgs: [localId],
            );
            return localId;
          } else {
            // No conversation exists, so insert a new one.
            int newId = await db.insert('conversation', conversationData);
            await _notifyConversations();
            return newId;
          }
        } else {
          // No conversation exists, so insert a new one.
          int newId = await db.insert('conversation', conversationData);
          await _notifyConversations();
          return newId;
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    print(conversationId);
    final db = await database;
    return await db.query(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getPendingMessages() async {
    final db = await database;
    return await db.query('messages', where: 'isSent = ?', whereArgs: [0]);
  }

  Future<int> updateMessageStatus(
      int id, int isSent, timestamp, mongooseId) async {
    final db = await database;
    int result = await db.update(
      'messages',
      {'isSent': isSent, 'timestamp': timestamp, 'mongooseId': mongooseId},
      where: 'id = ?',
      whereArgs: [id],
    );
    await _notifyListeners();
    return result;
  }

  Future<int> deleteMessage(String id) async {
    final db = await database;
    int result =
        await db.delete('messages', where: 'mongooseId = ?', whereArgs: [id]);
    await _notifyListeners();
    return result;
  }

  Future<void> _notifyListeners() async {
    final db = await database;
    List<Map<String, dynamic>> messages =
        await db.query('messages', orderBy: 'timestamp ASC');

    _messageSubject.add(messages); // BehaviorSubject caches the last event
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('messages');
    await db.delete('conversation');
    await _notifyListeners();
  }

  Future<bool> hasLocalConvo() async {
    final messages = await getConversations();
    return messages.isNotEmpty;
  }

  /// Retrieve all messages for a conversation from the backend and store them locally.
  Future<void> getAllConvo(WidgetRef ref) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getString('profile_id') ?? '';
      await ref.read(chatProviderController).getConversation(userId, ref);
      if (ref.read(chatProviderController).getConversatonResult.state ==
          GetConversatonResultState.isData) {
        final List<dynamic> newConvo =
            ref.read(chatProviderController).getConversatonResult.response;
        for (var convo in newConvo) {
          int? convoInsertedId;

          const email = 'Admin';
// Extract message IDs safely
          final convoIdSender = convo['conversationId_sender'];
          final convoIdReceiver = convo['conversationId_receiver'];

          if (convoIdSender != null && convoIdSender.contains('_')) {
            final idSender = convoIdSender.split('_')[1];

            if (idSender == email) {
              convoInsertedId = int.tryParse(convoIdSender.split('_')[0]);
            }
          }

          if (convoInsertedId == null &&
              convoIdReceiver != null &&
              convoIdReceiver.contains('_')) {
            convoInsertedId = int.tryParse(convoIdReceiver.split('_')[0]);
          }
          print('convo to insert $convo');
          // Insert each new message into the database.
          await insertOrUpdateConversation(convo, convo['conversationId']);
        }
      } else {
        print('Get All message sync');
      }
    } catch (e) {
      print('Error during Get All message sync: $e');
    }
  }

  Future<void> getAllConvoIncrement(WidgetRef ref, conversationId) async {
    try {
      final convo = await getConversations();
      if (convo.isEmpty) {
        print("No local messages found, consider doing a full sync.");
        return;
      }
      final lastMessageTimestamp = convo.last['createdAt'];
      await ref
          .read(chatProviderController)
          .syncMessage(conversationId, lastMessageTimestamp);
      if (ref.read(chatProviderController).syncLastChatResult.state ==
          SyncLastChatResultStates.isData) {
        print(ref.read(chatProviderController).syncLastChatResult.response);
        final List<dynamic> newConvo =
            ref.read(chatProviderController).syncLastChatResult.response;
        for (var convo in newConvo) {
          // Insert each new message into the database.
          await insertOrUpdateConversation(convo, convo['conversationId']);
        }
      } else {
        print('Get All message sync');
      }
    } catch (e) {
      print('Error during Get All message sync: $e');
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    final db = await database;
    await db.delete('messages',
        where: 'conversationId = ?', whereArgs: [conversationId]);
    await _notifyListeners();
  }

  void dispose() {
    _messageStreamController.close();
    _conversationStreamController.close();
  }

  // Optional: Save and retrieve sync flags for conversations, etc.
  Future<void> saveSyncTime(String conversationId, DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'syncTime_$conversationId', timestamp.toIso8601String());
  }

  Future<DateTime?> getLastSyncTime(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final syncTime = prefs.getString('syncTime_$conversationId');
    if (syncTime != null) {
      return DateTime.parse(syncTime);
    }
    return null;
  }

  Future<void> reinitializeDatabase() async {
    final db = await database;
    // Drop the messages table if it exists.
    await db.execute('DROP TABLE IF EXISTS messages');
    await db.execute('DROP TABLE IF EXISTS conversation');
    // Recreate the messages table.
    await _onCreate(db, 1);
    // Notify any listeners that the database has been reinitialized.
    await _notifyListeners();
    print("Database reinitialized successfully");
  }
}
