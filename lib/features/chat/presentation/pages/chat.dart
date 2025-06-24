import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
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
    if (_syncedConvoIds.contains(conversationId)) return;

    _syncedConvoIds.add(conversationId);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: false,
        leading: null,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0.1,
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.onBackground,
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onBackground,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Chat',
            style: TextStyle(
              fontSize: 20,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('images/bot.png'),
                  ),
                ),
                const Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Talk to Lola',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/Brain.png',
                          height: 15,
                          width: 15,
                          color: theme.colorScheme.primary,
                        ),
                        const Gap(5),
                        Text(
                          'Chat with AI for health tips',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const Gap(20),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _dbHelper.conversationStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something Went Wrong',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              }
              final conversations = snapshot.data!;
              if (conversations.isEmpty) {
                return Center(
                  child: Text(
                    'No conversations yet.',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                );
              }

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
        ]),
      ),
    );
  }

  Widget chatlist(BuildContext context, Map<dynamic, dynamic> doc) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
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
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
        ),
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
                          color: theme.colorScheme.primary,
                          value: progress.progress,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  imageUrl: doc['profile_pic'],
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    color: theme.colorScheme.error,
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
                  '${doc['first_name']} ${doc['last_name']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      'images/ChatCircle.png',
                      height: 15,
                      width: 15,
                      color: theme.colorScheme.primary,
                    ),
                    const Gap(5),
                    Text(
                      'New Chat',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.primary,
                      ),
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
