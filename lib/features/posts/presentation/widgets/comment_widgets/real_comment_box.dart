import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';
import 'package:h_smart/features/posts/domain/entities/getpostbyId.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'reply_box.dart';
import 'loading_reply_box.dart' as loading_reply_box;

class RealCommentBox extends ConsumerWidget {
  final Comment comment;
  final WidgetRef ref;
  final void Function(String userName) onReplyPressed;
  final List<Reply>? replies;
  final bool showLoadingReplyBox;
  final String? loadingReplyText;
  final String? loadingReplyUserName;
  final String? loadingReplyUserImage;
  final bool showShowMoreRepliesButton;
  final bool isLoadingMoreReplies;
  final VoidCallback onShowMoreReplies;

  const RealCommentBox({
    super.key,
    required this.comment,
    required this.ref,
    required this.onReplyPressed,
    this.replies,
    this.showLoadingReplyBox = false,
    this.loadingReplyText,
    this.loadingReplyUserName,
    this.loadingReplyUserImage,
    this.showShowMoreRepliesButton = false,
    this.isLoadingMoreReplies = false,
    required this.onShowMoreReplies,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userImage = comment.userImage ?? '';
    final userName = comment.userName ?? 'Anonymous';
    final commentText = comment.comment ?? '';
    final commentTime = comment.createdAt != null
        ? timeago.format(comment.createdAt!)
        : 'just now';

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ref.watch(themeModeCheckerProvider)(context)
            ? theme.colorScheme.surface
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            backgroundImage: userImage.isNotEmpty
                ? CachedNetworkImageProvider(userImage)
                : null,
            child: userImage.isEmpty
                ? Text(
                    userName.isNotEmpty ? userName[0] : '',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      commentTime,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Text(
                  commentText,
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Gap(6),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    onReplyPressed(userName);
                  },
                  child: Text(
                    'Reply',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                if ((replies ?? comment.replies)?.isNotEmpty ??
                    false || showLoadingReplyBox) ...[
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showLoadingReplyBox && loadingReplyText != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 6.0),
                          child: loading_reply_box.LoadingReplyBox(
                            userName: loadingReplyUserName ?? '',
                            userImage: loadingReplyUserImage ?? '',
                            replyText: loadingReplyText!,
                          ),
                        ),
                      ...((replies ?? comment.replies) ?? [])
                          .map((reply) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 6.0),
                                child: ReplyBox(
                                  reply: reply,
                                  ref: ref,
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
