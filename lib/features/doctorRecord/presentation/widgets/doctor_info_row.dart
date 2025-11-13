import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DoctorInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final ThemeData theme;

  const DoctorInfoRow({
    super.key,
    required this.icon,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}