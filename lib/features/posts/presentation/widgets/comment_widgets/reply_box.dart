import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/constant/AutoScrollText.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../domain/entities/getpostbyId.dart';

class ReplyBox extends ConsumerWidget {
  final Reply reply;
  final String? repliedToName;
  final WidgetRef ref;

  const ReplyBox({
    super.key,
    required this.reply,
    this.repliedToName,
    required this.ref,
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
                  children: [
                    AutoScrollText(
                      text: reply.userName ?? '',
                      maxWidth: MediaQuery.of(context).size.width * .4,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
