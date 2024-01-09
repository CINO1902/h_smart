import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: null,
          elevation: 0,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: const Text(
              'Chat',
              style: TextStyle(fontSize: 20),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffEBF1FF)),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                      backgroundImage: AssetImage(
                    'images/bot.png',
                  )),
                ),
                Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Talk to Lola',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: Image.asset('images/Brain.png')),
                        Gap(5),
                        Text(
                          'Chat with AI for health tips',
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Gap(20),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/ChatUi');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffEBF1FF)),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircleAvatar(
                        backgroundImage: AssetImage(
                      'images/doctorimage.png',
                    )),
                  ),
                  Gap(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dr. Alis William',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          SizedBox(
                              height: 15,
                              width: 15,
                              child: Image.asset('images/ChatCircle.png')),
                          Gap(5),
                          Text(
                            'New Chat',
                            style: TextStyle(fontSize: 13, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
