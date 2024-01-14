import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/chat/data/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> document = [];
  List<String> documentString = [];
  Future<void> sendmessage(String recieveId, String message1) async {
    final pref = await SharedPreferences.getInstance();

    final String curentuserID = pref.getString('email') ?? '';
    final Timestamp timestamp = Timestamp.now();
    print(curentuserID);

    Message newMessage = Message(
        senderId: curentuserID,
        message: message1,
        recieverID: recieveId,
        timestamp: timestamp);

    List<String> ids = [curentuserID, recieveId];
    ids.sort();
    String chatroomID = ids.join("_");
    await _firestore
        .collection("chatroom")
        .doc(chatroomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

void getpendingme(){
  
}

  Stream<QuerySnapshot> getmessages(String userID, String otheruserID) {
    List<String> ids = [userID, otheruserID];
    ids.sort();
    String chartroomID = ids.join("_");
    return _firestore
        .collection("chatroom")
        .doc(chartroomID)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  void update(authprovider authprovider) {}
}
