import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';
import 'reply_box.dart';

class CommentBox extends ConsumerStatefulWidget {
  final Map<String, dynamic> comment;
  final List<Map<String, dynamic>> mockComments;
  final WidgetRef ref;

  const CommentBox({
    super.key,
    required this.comment,
    required this.mockComments,
    required this.ref,
  });

  @override
  ConsumerState<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends ConsumerState<CommentBox> {
  int _repliesShown = 1;
  final int _repliesBatch = 5;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final comment = widget.comment;
    final ref = widget.ref;
    final replies = widget.mockComments
        .where((r) => r['type'] == 'reply' && r['replyTo'] == comment['id'])
        .toList();
    final totalReplies = replies.length;
    final shownReplies =
        _showAll ? replies : replies.take(_repliesShown).toList();
    final moreReplies = totalReplies - shownReplies.length;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 500),
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    backgroundImage: comment['avatar']!.isNotEmpty
                        ? CachedNetworkImageProvider(comment['avatar']!)
                        : null,
                    child: comment['avatar']!.isEmpty
                        ? Text(
                            comment['name']![0],
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
                              comment['name']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              comment['time']!,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Gap(4),
                        Text(
                          comment['comment']!,
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const Gap(6),
                        Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(40, 24),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Reply',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            if (replies.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '$totalReplies replies',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (replies.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final reply in shownReplies)
                                  ReplyWithRepliesBox(
                                    reply: reply,
                                    mockComments: widget.mockComments,
                                    ref: ref,
                                  ),
                                if (!_showAll && moreReplies > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _repliesShown += _repliesBatch;
                                          if (_repliesShown >= totalReplies) {
                                            _showAll = true;
                                          }
                                        });
                                      },
                                      child: Text(
                                        'View $moreReplies more replies',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_showAll && totalReplies > 1)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _repliesShown = 1;
                                          _showAll = false;
                                        });
                                      },
                                      child: Text(
                                        'View less replies',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyWithRepliesBox extends ConsumerStatefulWidget {
  final Map reply;
  final List<Map<String, dynamic>> mockComments;
  final WidgetRef ref;

  const ReplyWithRepliesBox({
    super.key,
    required this.reply,
    required this.mockComments,
    required this.ref,
  });

  @override
  ConsumerState<ReplyWithRepliesBox> createState() =>
      _ReplyWithRepliesBoxState();
}

class _ReplyWithRepliesBoxState extends ConsumerState<ReplyWithRepliesBox> {
  int _repliesShown = 1;
  final int _repliesBatch = 5;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reply = widget.reply;
    final ref = widget.ref;
    final replytoreplies = widget.mockComments
        .where(
            (r) => r['type'] == 'replytoreply' && r['replyTo'] == reply['id'])
        .toList();
    final totalReplies = replytoreplies.length;
    final shownReplies =
        _showAll ? replytoreplies : replytoreplies.take(_repliesShown).toList();
    final moreReplies = totalReplies - shownReplies.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReplyBox(reply: reply, ref: ref),
        if (replytoreplies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final replyToReply in shownReplies)
                  ReplyBox(
                    reply: replyToReply,
                    repliedToName: reply['name'],
                    ref: ref,
                  ),
                if (!_showAll && moreReplies > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _repliesShown += _repliesBatch;
                          if (_repliesShown >= totalReplies) {
                            _showAll = true;
                          }
                        });
                      },
                      child: Text(
                        'View $moreReplies more replies',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                if (_showAll && totalReplies > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _repliesShown = 1;
                          _showAll = false;
                        });
                      },
                      child: Text(
                        'View less replies',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
