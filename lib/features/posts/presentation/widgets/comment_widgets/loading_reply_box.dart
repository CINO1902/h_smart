import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';

class LoadingReplyBox extends ConsumerWidget {
  final String userName;
  final String userImage;
  final String replyText;

  const LoadingReplyBox({
    super.key,
    required this.userName,
    required this.userImage,
    required this.replyText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: 0.5,
      child: Container(
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
              backgroundImage: userImage.isNotEmpty
                  ? CachedNetworkImageProvider(userImage)
                  : null,
              child: userImage.isEmpty
                  ? Text(
                      userName.isNotEmpty ? userName[0] : '',
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
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    replyText,
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
      ),
    );
  }
}
