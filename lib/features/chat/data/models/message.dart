import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String recieverID;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.message,
      required this.recieverID,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverID': recieverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
