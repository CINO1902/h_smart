import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/posts/domain/entities/getpostbyId.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../domain/utils/states/postStates.dart';
import 'reply_box.dart';
import 'loading_reply_box.dart' as loading_reply_box;
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart'
    as post_entities;
import 'package:h_smart/features/posts/presentation/providers/posts_provider.dart';

class RealCommentBox extends ConsumerWidget {
  final Comment comment;
  final WidgetRef ref;
  final void Function(String userName) onReplyPressed;
  final void Function(String userName, String replyId, String commentId)?
      onReplyToReplyPressed;
  final List<Reply>? replies;
  final bool showLoadingReplyBox;
  final String? loadingReplyText;
  final String? loadingReplyUserName;
  final String? loadingReplyUserImage;
  final bool showShowMoreRepliesButton;
  final bool isLoadingMoreReplies;
  final VoidCallback onShowMoreReplies;
  final bool showNestedReplies;
  final bool showShowMoreNestedRepliesButton;
  final bool isLoadingMoreNestedReplies;
  final VoidCallback? onShowMoreNestedReplies;
  final bool showLoadingReplyToReplyBox;
  final String? loadingReplyToReplyText;
  final String? loadingReplyToReplyUserName;
  final String? loadingReplyToReplyUserImage;
  final String? replyingReplyId;
  final dynamic createReplyToReplyState;

  const RealCommentBox({
    super.key,
    required this.comment,
    required this.ref,
    required this.onReplyPressed,
    this.onReplyToReplyPressed,
    this.replies,
    this.showLoadingReplyBox = false,
    this.loadingReplyText,
    this.loadingReplyUserName,
    this.loadingReplyUserImage,
    this.showShowMoreRepliesButton = false,
    this.isLoadingMoreReplies = false,
    required this.onShowMoreReplies,
    this.showNestedReplies = false,
    this.showShowMoreNestedRepliesButton = false,
    this.isLoadingMoreNestedReplies = false,
    this.onShowMoreNestedReplies,
    this.showLoadingReplyToReplyBox = false,
    this.loadingReplyToReplyText,
    this.loadingReplyToReplyUserName,
    this.loadingReplyToReplyUserImage,
    this.replyingReplyId,
    this.createReplyToReplyState,
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
                if (((replies ?? comment.replies?.replies) != null &&
                        (replies ?? comment.replies?.replies)!.isNotEmpty) ||
                    showLoadingReplyBox) ...[
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
                      ...((replies ?? comment.replies?.replies) ?? [])
                          .map((reply) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 6.0),
                                child: ReplyBox(
                                  reply: reply,
                                  ref: ref,
                                  onReplyToReplyPressed:
                                      onReplyToReplyPressed == null
                                          ? null
                                          : (userName, replyId, _) =>
                                              onReplyToReplyPressed!(userName,
                                                  replyId, comment.id ?? ''),
                                  parentCommentId: comment.id ?? '',
                                  showNestedReplies: showNestedReplies,
                                  showShowMoreNestedRepliesButton:
                                      showShowMoreNestedRepliesButton,
                                  isLoadingMoreNestedReplies: ref
                                      .read(postsProvider.notifier)
                                      .isLoadingMoreNestedRepliesForReply(
                                          reply.id ?? ''),
                                  onShowMoreNestedReplies: () {
                                    ref
                                        .read(postsProvider.notifier)
                                        .loadMoreNestedReplies(reply.id ?? '');
                                  },
                                  showLoadingReplyToReplyBox:
                                      createReplyToReplyState ==
                                              CreateReplytoReplyState
                                                  .isLoading &&
                                          loadingReplyToReplyText != null &&
                                          replyingReplyId == reply.id,
                                  loadingReplyToReplyText:
                                      loadingReplyToReplyText,
                                  loadingReplyToReplyUserName:
                                      loadingReplyToReplyUserName,
                                  loadingReplyToReplyUserImage:
                                      loadingReplyToReplyUserImage,
                                ),
                              ))
                          .toList(),
                      if (showShowMoreRepliesButton)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 4.0),
                          child: GestureDetector(
                            onTap:
                                isLoadingMoreReplies ? null : onShowMoreReplies,
                            child: isLoadingMoreReplies
                                ? const ShimmerReplyBox()
                                : const Text(
                                    'Show more replies',
                                    style: TextStyle(
                                        color: AppColors.kprimaryColor500),
                                  ),
                          ),
                        ),
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

class ShimmerReplyBox extends StatelessWidget {
  const ShimmerReplyBox({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color.fromARGB(255, 61, 61, 61)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar shimmer
          ShimmerWidget(
            height: 28,
            width: 28,
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.18,
                    ),
                    const Gap(6),
                    ShimmerWidget(
                      height: 11,
                      width: 40,
                    ),
                  ],
                ),
                const Gap(2),
                ShimmerWidget(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
