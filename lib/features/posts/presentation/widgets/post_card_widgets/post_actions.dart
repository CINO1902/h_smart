import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class PostActions extends StatelessWidget {
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final VoidCallback? onLikePressed;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onSharePressed;

  const PostActions({
    super.key,
    required this.likesCount,
    required this.commentsCount,
    this.viewsCount = 0,
    this.onLikePressed,
    this.onCommentPressed,
    this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionIcon(
          icon: Icons.favorite_border,
          label: '$likesCount',
          color: theme.colorScheme.error,
          onPressed: onLikePressed,
        ),
        _ActionIconSvg(
          svgIcon: 'images/comment.svg',
          label: '$commentsCount',
          color: theme.colorScheme.primary,
          onPressed: onCommentPressed,
        ),
        _ActionIcon(
          icon: Icons.bar_chart,
          label: '$viewsCount',
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          onPressed: onSharePressed,
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const Gap(4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIconSvg extends StatelessWidget {
  final String svgIcon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionIconSvg({
    required this.svgIcon,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(svgIcon, width: 20, height: 20),
          const Gap(4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
