import 'package:flutter/material.dart';

class InkButton extends StatelessWidget {
  const InkButton({
    super.key,
    required this.title,
    this.active,
  });
  final String title;
  final bool? active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: active != null
            ? theme.colorScheme.primary.withOpacity(0.5)
            : theme.colorScheme.primary,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
