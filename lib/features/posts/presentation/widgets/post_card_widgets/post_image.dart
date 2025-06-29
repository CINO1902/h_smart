import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart';
import 'package:h_smart/features/posts/presentation/widgets/shared_widgets/fullview.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final Post post;

  const PostImage({
    super.key,
    required this.imageUrl,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        showDialog(
          useSafeArea: false,
          context: context,
          builder: (_) {
            return Fullview(
              imageUrl: imageUrl,
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
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
            errorWidget: (context, url, error) => Container(
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
    );
  }
}
