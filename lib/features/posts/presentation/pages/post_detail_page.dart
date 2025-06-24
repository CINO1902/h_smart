import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/AutoScrollText.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart';
import 'package:h_smart/features/posts/presentation/widgets/fullview.dart';

import '../../../../core/theme/theme_mode_provider.dart';


class PostDetailPage extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _mockComments = [
    {
      'avatar': '',
      'id': '1',
      'name': 'Jane Doe',
      'time': '2h',
      'type': 'comment',
      'replyTo': '12323',
      'comment': 'This is so insightful!',
      'moreReplies': 20,
    },
    {
      'id': '2',
      'avatar': '',
      'name': 'John Smith',
      'time': '1h',
      'type': 'comment',
      'replyTo': '12323',
      'comment': 'Thanks for sharing.',
      'moreReplies': 0,
    },
    {
      'id': '1',
      'avatar': '',
      'name': 'Caleb Smith',
      'time': '1h',
      'replyTo': '1',
      'comment': 'Thanks for sharing.',
      'type': 'reply',
      'moreReplies': 0,
    },
    {
      'id': '2',
      'avatar': '',
      'name': 'Samuel Smith',
      'time': '1h',
      'replyTo': '1',
      'comment': 'No thank you for sharing.',
      'type': 'reply',
      'moreReplies': 0,
    },
    {
      'id': '3',
      'avatar': '',
      'name': 'Jude Stone',
      'time': '1h',
      'replyTo': '1',
      'comment': 'No thank you for sharing.',
      'type': 'reply',
      'moreReplies': 0,
    },
    {
      'id': '4',
      'avatar': '',
      'name': 'Token ned',
      'time': '1h',
      'replyTo': '1',
      'comment': 'No thank you for sharing.',
      'type': 'reply',
      'moreReplies': 0,
    },
    {
      'id': '5',
      'avatar': '',
      'name': 'Parker lee',
      'time': '1h',
      'replyTo': '1',
      'comment': 'No thank you for sharing.',
      'type': 'reply',
      'moreReplies': 0,
    },
    {
      'id': '6',
      'avatar': '',
      'name': 'Lee mon',
      'time': '1h',
      'replyTo': '1',
      'comment': 'No thank you for sharing.',
      'type': 'reply',
      'moreReplies': 0,
    },
    {
      'id': '7',
      'avatar': '',
      'name': 'Lee mon',
      'time': '1h',
      'replyTo': '1',
      'comment': 'No thank you for sharing.',
      'type': 'reply',
      'moreReplies': 0,
    },
    {
      'id': '8',
      'avatar': '',
      'name': 'Lee mon',
      'time': '1h',
      'replyTo': '1',
      'comment': 'No thank you for sharing.',
      'type': 'reply',
      'moreReplies': 0,
    },
    {
      'id': '1',
      'avatar': '',
      'name': 'Reply Smith',
      'time': '1h',
      'replyTo': '1',
      'comment': 'Thanks for sharing.',
      'type': 'replytoreply',
      'moreReplies': 0,
    },
    {
      'id': '4',
      'avatar': '',
      'name': 'Alice',
      'time': '30m',
      'type': 'comment',
      'replyTo': '12323',
      'comment': 'Great post!',
      'moreReplies': 0,
    },
  ];
  bool _expanded = false;
  bool _showSeeMore = false;
  final int _maxLines = 6;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final textSpan = TextSpan(text: widget.post.content);
      final tp = TextPainter(
        text: textSpan,
        maxLines: _maxLines,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: MediaQuery.of(context).size.width - 32);
      if (tp.didExceedMaxLines) {
        setState(() {
          _showSeeMore = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final post = widget.post;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
                elevation: 0,
                floating: true,
                snap: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: theme.colorScheme.onSurface),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  'Post',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.more_horiz,
                        color: theme.colorScheme.onSurface),
                    onPressed: () {},
                  ),
                ],
                centerTitle: false,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Card
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withOpacity(0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  child: Text(
                                    post.doctorName[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const Gap(12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.doctorName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const Gap(2),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Doctor',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const Gap(8),
                                        Text(
                                          '2h ago',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(Icons.more_vert,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6)),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const Gap(14),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.content,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    maxLines: _expanded ? null : _maxLines,
                                    overflow: _expanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                  ),
                                  if (_showSeeMore && !_expanded)
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _expanded = true),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          'See more',
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (post.fileContent != null) ...[
                              const Gap(5),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    useSafeArea: false,
                                    context: context,
                                    builder: (_) {
                                      return Fullview(
                                        imageUrl: post.fileContent!,
                                        doctorName: post.doctorName,
                                        postText: post.content,
                                        likesCount: post.likesCount,
                                        commentsCount: post.commentsCount,
                                      );
                                    },
                                    barrierColor: Colors.black,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: post.fileContent!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: theme.colorScheme.surfaceVariant,
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: theme.colorScheme.surfaceVariant,
                                        height: 200,
                                        child: Icon(
                                          Icons.error,
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _ActionIcon(
                                  icon: Icons.favorite_border,
                                  label: '${post.likesCount}',
                                  color: theme.colorScheme.error,
                                ),
                                _ActionIconSvg(
                                  svgIcon: 'images/comment.svg',
                                  label: '${post.commentsCount}',
                                  color: theme.colorScheme.primary,
                                ),
                                _ActionIcon(
                                  icon: Icons.bar_chart,
                                  label: '23223',
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          'Comments',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final comment = _mockComments[index];
                    if (comment['type'] != 'comment')
                      return const SizedBox.shrink();
                    // Find replies to this comment
                    final replies = _mockComments
                        .where((r) =>
                            r['type'] == 'reply' &&
                            r['replyTo'] == comment['id'])
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: _CommentBox(
                          comment: comment,
                          mockComments: _mockComments,
                          ref: ref),
                    );
                  },
                  childCount: _mockComments.length,
                ),
              ),
              const SliverToBoxAdapter(child: Gap(80)),
            ],
          ),
          // Comment input
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        minLines: 1,
                        maxLines: 4,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceVariant,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Material(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          // TODO: Add comment logic
                          _commentController.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.send,
                            color: theme.colorScheme.onPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionIcon(
      {required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const Gap(4),
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _ActionIconSvg extends StatelessWidget {
  final String svgIcon;
  final String label;
  final Color color;
  const _ActionIconSvg(
      {required this.svgIcon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(svgIcon, width: 20, height: 20),
        const Gap(4),
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class _CommentBox extends StatefulWidget {
  final Map<String, dynamic> comment;
  final List<Map<String, dynamic>> mockComments;
  final WidgetRef ref;
  const _CommentBox(
      {required this.comment, required this.mockComments, required this.ref});

  @override
  State<_CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<_CommentBox> {
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
                                  _ReplyWithRepliesBox(
                                      reply: reply,
                                      mockComments: widget.mockComments,
                                      ref: ref),
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

class _ReplyWithRepliesBox extends StatefulWidget {
  final Map reply;
  final List<Map<String, dynamic>> mockComments;
  final WidgetRef ref;
  const _ReplyWithRepliesBox(
      {required this.reply, required this.mockComments, required this.ref});
  @override
  State<_ReplyWithRepliesBox> createState() => _ReplyWithRepliesBoxState();
}

class _ReplyWithRepliesBoxState extends State<_ReplyWithRepliesBox> {
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
        _ReplyBox(reply: reply, ref: ref),
        if (replytoreplies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final replyToReply in shownReplies)
                  _ReplyBox(
                      reply: replyToReply,
                      repliedToName: reply['name'],
                      ref: ref),
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

class _ReplyBox extends StatelessWidget {
  final Map reply;
  final String? repliedToName;
  final WidgetRef ref;
  const _ReplyBox({required this.reply, this.repliedToName, required this.ref});
  @override
  Widget build(BuildContext context) {
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
                reply['avatar'] != null && reply['avatar'].isNotEmpty
                    ? CachedNetworkImageProvider(reply['avatar'])
                    : null,
            child: (reply['avatar'] == null || reply['avatar'].isEmpty)
                ? Text(
                    reply['name'][0],
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
                  children: [
                    if (reply['type'] == 'replytoreply' &&
                        repliedToName != null)
                      AutoScrollText(
                        text: '${reply['name']} replied to $repliedToName',
                        maxWidth: MediaQuery.of(context).size.width * .4,
                        align: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      )
                    else
                      AutoScrollText(
                        text: reply['name'],
                        maxWidth: MediaQuery.of(context).size.width * .5,
                        align: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    const Gap(6),
                    Text(
                      reply['time'],
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Gap(2),
                Text(
                  reply['comment'],
                  style: TextStyle(
                    fontSize: 14,
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
