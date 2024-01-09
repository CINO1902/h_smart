import 'package:flutter/material.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Row(
            children: [
              SizedBox(
                  height: 15,
                  width: 15,
                  child: Image.asset('images/doctorimage.png')),
            ],
          )
        ]),
      ),
    );
  }
}
