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
    Future.delayed(const Duration(milliseconds: 100), () {
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Stack(children: [
          Align(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(top: 70),
                      child: _buildmessageList()),
                ),
                Container(
                  height: 47,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/attachment.png',
                        height: 20,
                        width: 20,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      const Gap(5),
                      Expanded(
                        child: TextField(
                          controller: messagecontroller,
                          minLines: 1,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            constraints: const BoxConstraints(minHeight: 20),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 0,
                            ),
                            border: InputBorder.none,
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      const Gap(5),
                      InkWell(
                        onTap: _sendMessage,
                        child: Image.asset(
                          'images/send.png',
                          height: 20,
                          width: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: theme.colorScheme.surface,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Gap(15),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.profile_pic,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceVariant,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.firstname} ${widget.lastname}',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Online',
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildmessageList() {
    final theme = Theme.of(context);
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _dbHelper.getMessagesForConversation(widget.conversationID),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No messages yet',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          );
        }

        final messages = snapshot.data!;
        return ListView.builder(
          controller: _controller,
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isFromMe = message['sender'] == '67d2eddda33c0f86f2e9938d';

            return Align(
              alignment:
                  isFromMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: ChatBubble(
                  message: message['content'] as String,
                  backgroundColor: isFromMe
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceVariant,
                  isFromMe: isFromMe,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class chatInput extends StatelessWidget {
  const chatInput({super.key, required this.sendmessages});

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
                  border: Border.all(color: const Color(0xffEDEDED))),
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
