import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/chat/presentation/pages/chatUi.dart';
import '../../domains/utils/DatabaseHelper.dart';

class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Set<String> _syncedConvoIds = {};

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _dbHelper.initializeConversations();
      await callconvo();
    });
  }

  Future<void> _syncMessages(String conversationId) async {
    if (_syncedConvoIds.contains(conversationId)) return; // already synced

    _syncedConvoIds.add(conversationId); // mark as synced
    debugPrint('Conversation id: $conversationId');
    bool exists = await DatabaseHelper().hasLocalMessages(conversationId);
    debugPrint('Local messages exist: $exists');
    if (!exists) {
      debugPrint('Fetching all messages for conversation: $conversationId');
      await DatabaseHelper().getAllMessage(conversationId, ref);
    } else {
      await DatabaseHelper().incrementalSync(conversationId, ref);
    }
  }

  Future<void> callconvo() async {
    bool exists = await DatabaseHelper().hasLocalConvo();
    if (!exists) {
      await _dbHelper.initializeMessage();
      await DatabaseHelper().getAllConvo(ref);
    } else {
      await _dbHelper.initializeMessage();
      // await DatabaseHelper().getAllConvoIncrement(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: null,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Chat',
              style: TextStyle(fontSize: 20),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                    const Text(
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
                        const Gap(5),
                        const Text(
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
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _dbHelper.conversationStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something Went Wrong'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final conversations = snapshot.data!;
              if (conversations.isEmpty) {
                return const Center(child: Text('No conversations yet.'));
              }

              // context.read<ChatService>().getListFromFireBase(
              //     context.watch<authprovider>().email, snapshot.data!.docs);

              return ListView.builder(
                shrinkWrap: true,
                itemCount: conversations.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final convo = conversations[index];
                  _syncMessages(convo['conversationId']);
                  return chatlist(context, convo);
                },
              );
            },
          ),
          //  chatlist(context);
        ]),
      ),
    );
  }

  Widget chatlist(BuildContext context, Map<dynamic, dynamic> doc) {
    return InkWell(
      onTap: () {
        //  Navigator.pushNamed(context, '/ChatUi');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatUI(
                firstname: doc['first_name'],
                profile_pic: doc['profile_pic'],
                lastname: doc['last_name'],
                email: doc['id'],
                conversationID: doc['conversationId'],
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffEBF1FF)),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
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
                  imageUrl: doc['profile_pic'],
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  doc['first_name'] + ' ' + doc['last_name'],
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    SizedBox(
                        height: 15,
                        width: 15,
                        child: Image.asset('images/ChatCircle.png')),
                    const Gap(5),
                    const Text(
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
    );
  }
}
