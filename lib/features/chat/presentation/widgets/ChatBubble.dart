import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final bool isFromMe;
  const ChatBubble({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.isFromMe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      constraints: const BoxConstraints(
          maxWidth: 250, minWidth: 70, maxHeight: 500, minHeight: 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: isFromMe
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
