import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/chat/presentation/provider/chatservice.dart';
import 'package:h_smart/features/chat/presentation/widgets/ChatBubble.dart';
import 'package:h_smart/features/doctorRecord/presentation/provider/doctorprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatUI extends StatefulWidget {
  ChatUI(
      {super.key,
      required this.firstname,
      required this.profile_pic,
      required this.lastname,
      required this.email});
  String firstname;
  String lastname;
  String profile_pic;
  String email;
  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final TextEditingController messagecontroller = TextEditingController();
  final ChatService _chatService = ChatService();
  // bool send

  void sendmessage() async {
    if (messagecontroller.text.isNotEmpty) {
      await _chatService.sendmessage(widget.email, messagecontroller.text);

      messagecontroller.clear();
      setState(() {
        loaded = true;
      });
      _scrollDown();
      //_scrollDown();
    }
  }

  String email = '';
  int bookindex = 0;
  bool loaded = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getemail();

    _controller.addListener(_scrollListener);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    // _controller.
  }

  final ScrollController _controller = ScrollController();
  void getemail() async {
    final pref = await SharedPreferences.getInstance();

    setState(() {
      email = pref.getString('email') ?? '';
    });
  }

  void _scrollDown() {
    if (loaded == true) {
      Future.delayed(const Duration(milliseconds: 50), () {
        print('object');
        _controller.jumpTo(
          _controller.position.maxScrollExtent,
        );
      }).then((value) => deactivatescroll());
    }
  }

  void deactivatescroll() {
    Future.delayed(Duration(milliseconds: 100), () {
      print('object1');
      loaded = false;
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print('here');
      loaded = true;
    }
  }

  // checknewmessage(index) {
  //   bookindex = index;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Align(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(top: 70),
                      child: _buildmessageList()),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffEDEDED))),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/attachment.png',
                        height: 20,
                        width: 20,
                      ),
                      Gap(5),
                      Expanded(
                          child: TextField(
                        controller: messagecontroller,
                        minLines: 1,
                        maxLines: 3,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            constraints: BoxConstraints(minHeight: 20),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            border: InputBorder.none),
                      )),
                      Gap(5),
                      InkWell(
                        onTap: sendmessage,
                        child: Image.asset(
                          'images/send.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 70,
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'images/chevron-left.png',
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                    Gap(15),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) {
                            return Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                  value: progress.progress,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          imageUrl: widget.profile_pic,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Gap(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 180,
                          child: Text(
                            widget.firstname + ' ' + widget.lastname,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                              width: 5,
                              child: SvgPicture.asset('images/dot.svg',
                                  color: Colors.green),
                            ),
                            Gap(5),
                            Text(
                              'Online',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.green),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'images/voice_call.png',
                      height: 30,
                      width: 30,
                    ),
                    Gap(10),
                    Image.asset(
                      'images/video_call.png',
                      height: 30,
                      width: 30,
                    )
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildmessageList() {
    return StreamBuilder(
      stream: _chatService.getmessages(widget.email, email),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          controller: _controller,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            // checknewmessage(
            //   snapshot.data!.docs.length,
            // );
            // bookindex = snapshot.data!.docs.length;
            _scrollDown();
            return _buildmessageItem(
              snapshot.data!.docs,
              index,
              snapshot.data!.docs.length,
            );
          },
          // children: snapshot.data!.docs
          //     .map((document) => _buildmessageItem(document))
          //     .toList(),
        );
      },
    );
  }

  Widget _buildmessageItem(document, index, length) {
    var alignment = (document[index]['senderId'] == email)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        margin: EdgeInsets.only(bottom: 10),
        alignment: alignment,
        child: (document[index]['senderId'] == email)
            ? ChatBubble(
                message: document[index]['message'],
                color: Color(0xffF3F7FF),
              )
            : length != index + 1
                ? document[index]['recieverID'] !=
                        document[index + 1]['recieverID']
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor,
                                        value: progress.progress,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                imageUrl: widget.profile_pic,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          ChatBubble(
                            message: document[index]['message'],
                            color: Color(0xffEDEDED),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          ChatBubble(
                            message: document[index]['message'],
                            color: Color(0xffEDEDED),
                          ),
                        ],
                      )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                    value: progress.progress,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            imageUrl: widget.profile_pic,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      ChatBubble(
                        message: document[index]['message'],
                        color: Color(0xffEDEDED),
                      )
                    ],
                  ));
  }
}
