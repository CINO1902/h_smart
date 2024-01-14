import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  ChatBubble({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      constraints: BoxConstraints(
          maxWidth: 250, minWidth: 70, maxHeight: 500, minHeight: 50),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
