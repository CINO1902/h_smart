import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/constant/AutoScrollText.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'loading_reply_box.dart';

import '../../../domain/entities/getpostbyId.dart';

class NestedReplyBox extends ConsumerWidget {
  final Reply reply;
  final WidgetRef ref;

  const NestedReplyBox({
    super.key,
    required this.reply,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ref.watch(themeModeCheckerProvider)(context)
            ? const Color.fromARGB(255, 51, 51, 51)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            backgroundImage:
                reply.userImage != null && reply.userImage!.isNotEmpty
                    ? CachedNetworkImageProvider(reply.userImage!)
                    : null,
            child: (reply.userImage == null || reply.userImage!.isEmpty)
                ? Text(
                    reply.userName?[0] ?? '',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  )
                : null,
          ),
          const Gap(6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoScrollText(
                      text: reply.userName ?? '',
                      maxWidth: MediaQuery.of(context).size.width * .25,
                      align: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      reply.createdAt != null
                          ? timeago.format(reply.createdAt!)
                          : 'just now',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const Gap(1),
                Text(
                  reply.reply ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyBox extends ConsumerWidget {
  final Reply reply;
  final String? repliedToName;
  final WidgetRef ref;
  final void Function(String userName, String replyId, String commentId)?
      onReplyToReplyPressed;
  final bool showNestedReplies;
  final bool showShowMoreNestedRepliesButton;
  final bool isLoadingMoreNestedReplies;
  final VoidCallback? onShowMoreNestedReplies;
  final bool showLoadingReplyToReplyBox;
  final String? loadingReplyToReplyText;
  final String? loadingReplyToReplyUserName;
  final String? loadingReplyToReplyUserImage;
  final String? parentCommentId;

  const ReplyBox({
    super.key,
    required this.reply,
    this.repliedToName,
    required this.ref,
    this.onReplyToReplyPressed,
    this.parentCommentId,
    this.showNestedReplies = false,
    this.showShowMoreNestedRepliesButton = false,
    this.isLoadingMoreNestedReplies = false,
    this.onShowMoreNestedReplies,
    this.showLoadingReplyToReplyBox = false,
    this.loadingReplyToReplyText,
    this.loadingReplyToReplyUserName,
    this.loadingReplyToReplyUserImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ref.watch(themeModeCheckerProvider)(context)
            ? const Color.fromARGB(255, 61, 61, 61)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            backgroundImage:
                reply.userImage != null && reply.userImage!.isNotEmpty
                    ? CachedNetworkImageProvider(reply.userImage!)
                    : null,
            child: (reply.userImage == null || reply.userImage!.isEmpty)
                ? Text(
                    reply.userName?[0] ?? '',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                : null,
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
                    AutoScrollText(
                      text: reply.userName ?? '',
                      maxWidth: MediaQuery.of(context).size.width * .3,
                      align: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      reply.createdAt != null
                          ? timeago.format(reply.createdAt!)
                          : 'just now',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Gap(2),
                Text(
                  reply.reply ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Gap(4),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 20),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: onReplyToReplyPressed != null
                          ? () => onReplyToReplyPressed!(reply.userName ?? '',
                              reply.id ?? '', parentCommentId ?? '')
                          : null,
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (showNestedReplies &&
                    reply.repliesToReplies?.replies != null) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showLoadingReplyToReplyBox &&
                          loadingReplyToReplyText != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 4.0),
                          child: LoadingReplyBox(
                            userName: loadingReplyToReplyUserName ?? '',
                            userImage: loadingReplyToReplyUserImage ?? '',
                            replyText: loadingReplyToReplyText!,
                          ),
                        ),
                      ...reply.repliesToReplies!.replies!
                          .map((nestedReply) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 4.0),
                                child: NestedReplyBox(
                                  reply: nestedReply,
                                  ref: ref,
                                ),
                              ))
                          .toList(),
                      if (reply.repliesToReplies!.replies!.length <
                          (reply.repliesToReplies!.totalCount ?? 0))
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 2.0),
                          child: GestureDetector(
                            onTap: isLoadingMoreNestedReplies
                                ? null
                                : onShowMoreNestedReplies,
                            child: isLoadingMoreNestedReplies
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: ref.watch(
                                              themeModeCheckerProvider)(context)
                                          ? const Color.fromARGB(
                                              255, 51, 51, 51)
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShimmerWidget(height: 24, width: 24),
                                        Gap(6),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ShimmerWidget(
                                                      height: 10, width: 60),
                                                  const Gap(4),
                                                  ShimmerWidget(
                                                      height: 8, width: 40),
                                                ],
                                              ),
                                              Gap(1),
                                              ShimmerWidget(
                                                  height: 10, width: 120),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const Text(
                                    'Show more replies',
                                    style: TextStyle(
                                        color: AppColors.kprimaryColor500,
                                        fontSize: 12),
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
