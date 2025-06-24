import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String iconName;
  final VoidCallback onTap;

  const ProfileItem({
    Key? key,
    required this.title,
    required this.iconName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Image.asset(
                'images/$iconName.png',
                width: 24,
                height: 24,
                color: theme.colorScheme.primary,
              ),
              const Gap(10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
