import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart';

import '../../../../../constant/SchimmerWidget.dart';
import '../../../../../core/utils/appColor.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final VoidCallback? onMorePressed;

  const PostHeader({
    super.key,
    required this.post,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        post.userProfileUrl == null
            ? CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.kprimaryColor500.withOpacity(0.1),
                child: Text(
                  post.doctorName?[0].toUpperCase() ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kprimaryColor500,
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: post.userProfileUrl ?? '',
                  height: 40,
                  width: 40,
                  placeholder: (context, url) => const ShimmerWidget(
                    height: 24,
                    width: 24,
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 40),
                ),
              ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.doctorName ?? '',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
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
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: onMorePressed,
        ),
      ],
    );
  }
}
