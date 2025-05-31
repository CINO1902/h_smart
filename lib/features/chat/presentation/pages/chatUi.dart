import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/auth/presentation/controller/auth_controller.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/chat/presentation/controller/chatservice.dart';
import 'package:h_smart/features/chat/presentation/widgets/ChatBubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/socketClass.dart';
import '../../../../core/utils/appColor.dart';
import '../../domains/utils/DatabaseHelper.dart';

class ChatUI extends ConsumerStatefulWidget {
  ChatUI(
      {super.key,
      required this.firstname,
      required this.profile_pic,
      required this.conversationID,
      required this.lastname,
      required this.email});
  String firstname;
  String lastname;
  String profile_pic;
  String conversationID;
  String email;
  @override
  ConsumerState<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends ConsumerState<ChatUI> {
  final TextEditingController messagecontroller = TextEditingController();
  late final SocketService socketService;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  // bool send
  int unreadCount = 0;
  int newMessageCount = 0;
  DateTime newMessageThreshold = DateTime.now();
  void resetNewMessageIndicator() {
    if (mounted) {
      setState(() {
        newMessageThreshold = DateTime.now(); // Set threshold to now
        newMessageCount = 0; // Reset count
      });
    }
  }

  Future<void> _sendMessage() async {
    resetNewMessageIndicator();
    setState(() {
      unreadCount = 0;
    });
    final content = messagecontroller.text.trim();
    if (content.isEmpty) return;

    const senderId = '67d2eddda33c0f86f2e9938d';
    const senderLabel = 'Admin';
    final currentTime = DateTime.now().toIso8601String();

    // Build conversation data.
    final conversationData = {
      "_id": widget.conversationID,
      "participants": [
        {
          "firstname": widget.firstname,
          "lastname": widget.lastname,
          "email": widget.email,
          "image_url": widget.profile_pic,
        }
      ],
      "createdAt": currentTime,
      "updatedAt": currentTime,
      "__v": 0,
      "lastMessage": {
        "content": content,
        "createdAt": currentTime,
      },
    };

    // Update or insert the conversation locally.
    final int updatedConvoId = await _dbHelper.insertOrUpdateConversation(
      conversationData,
      int.parse(widget.conversationID),
    );

    // Build the message data.
    final messageData = {
      'conversationId': widget.conversationID,
      'convoId': updatedConvoId,
      'sender': senderId,
      'recipient': widget.email,
      'content': content,
      'timestamp': currentTime,
      'isSent': 0, // Pending confirmation from backend.
      'isRead': 0,
    };

    // Insert the message locally.
    final int insertedMessageId = await _dbHelper.insertMessage(messageData);

    debugPrint('Updated conversation id: $updatedConvoId');

    final joinedMessageId = '${insertedMessageId}_$senderLabel';
    final joinedConvoId = '${updatedConvoId}_$senderLabel';

    // Send the message via the socket.
    socketService.sendMessage(
      sender: senderLabel,
      messageId: joinedMessageId,
      conversationId: joinedConvoId,
      recipient: widget.email,
      content: content,
    );

    // Clear the input field.
    messagecontroller.clear();

    // Scroll to the bottom.
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_controller.hasClients) {
      _controller.animateTo(
        0.0, // In reverse mode, 0.0 represents the bottom.
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
                  height: 47,
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
                        onTap: _sendMessage,
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
                            color: AppColors.kprimaryColor500,
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
                                  color: AppColors.kprimaryColor500,
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
      stream: _dbHelper.messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // Get all messages for this conversation.
        final messages = snapshot.data!
            .where((msg) => msg['conversationId'] == widget.conversationID)
            .toList();

        if (messages.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }

        // Compute new messages based solely on the timestamp.
        final newMessages = messages.where((msg) {
          final DateTime msgTime =
              DateTime.parse(msg['timestamp']).toUtc().toLocal();
          return (msgTime.isAfter(newMessageThreshold) ||
                  msgTime.isAtSameMomentAs(newMessageThreshold)) &&
              msg['sender'] !=
                  ref
                      .read(authProvider)
                      .userData
                      .id; // Exclude messages sent by you
        }).toList();

        // Update our state with the new message count if it has changed.
        if (newMessages.length != newMessageCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                newMessageCount = newMessages.length;
              });
            }
          });
        }

        // Find the first message that is considered new.
        int dividerIndex = messages.indexWhere((msg) {
          final DateTime msgTime =
              DateTime.parse(msg['timestamp']).toUtc().toLocal();
          return (msgTime.isAfter(newMessageThreshold) ||
                  msgTime.isAtSameMomentAs(newMessageThreshold)) &&
              msg['sender'] != ref.read(authProvider).userData.id;
        });
        if (dividerIndex == -1 || newMessageCount == 0) {
          dividerIndex = -1;
        }

        // Adjust total items if we need to insert a divider.
        final int totalItems = messages.length + (dividerIndex != -1 ? 1 : 0);

        return ListView.builder(
          shrinkWrap: true,
          controller: _controller,
          itemCount: totalItems,
          itemBuilder: (context, index) {
            // checknewmessage(
            //   snapshot.data!.docs.length,
            // );
            // bookindex = snapshot.data!.docs.length;
            _scrollDown();
            return _buildmessageItem(newMessages, index, totalItems);
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
                                        color: AppColors.kprimaryColor500,
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
                                    color: AppColors.kprimaryColor500,
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

class chatInput extends StatelessWidget {
  chatInput({super.key, required this.sendmessages});

  final VoidCallback sendmessages;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .01,
          horizontal: MediaQuery.of(context).size.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffEDEDED))),
              child: Row(
                children: [
                  //emoji button
                  SizedBox(width: MediaQuery.of(context).size.width * .04),
                  Image.asset(
                    'images/attachment.png',
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .02),
                  Expanded(
                      child: TextField(
                    //  controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    minLines: 1,
                    onTap: () {},
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none),
                  )),
                  SizedBox(width: MediaQuery.of(context).size.width * .02),
                  InkWell(
                    onTap: sendmessages,
                    child: Image.asset(
                      'images/send.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .04),
                ],
              ),
            ),
          ),

          //send message button
        ],
      ),
    );
  }
}
