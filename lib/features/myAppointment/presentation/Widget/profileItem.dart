
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFC1D3FF)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Image.asset(
                'images/$iconName.png',
                width: 24,
                height: 24,
              ),
              const Gap(10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
