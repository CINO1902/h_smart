import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart';
import '../index.dart';

class PostCardDetail extends StatelessWidget {
  final Post post;
  final VoidCallback? onMorePressed;
  final VoidCallback? onLikePressed;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onSharePressed;

  const PostCardDetail({
    super.key,
    required this.post,
    this.onMorePressed,
    this.onLikePressed,
    this.onCommentPressed,
    this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
          PostHeader(
            post: post,
            onMorePressed: onMorePressed,
          ),
          const Gap(14),
          ExpandableText(text: post.content ?? ''),
          if (post.fileContent != null) ...[
            const Gap(5),
            PostImage(
              imageUrl: post.fileContent!,
              post: post,
            ),
          ],
          const Gap(16),
          PostActions(
            likesCount: post.likesCount ?? 0,
            commentsCount: post.commentsCount ?? 0,
            viewsCount: 23223, // This should come from post data
            onLikePressed: onLikePressed,
            onCommentPressed: onCommentPressed,
            onSharePressed: onSharePressed,
          ),
        ],
      ),
    );
  }
}
