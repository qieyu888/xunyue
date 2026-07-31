import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.fontSize = 13,
    this.borderRadius = 999,
  });

  final String label;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final double fontSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: padding,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FollowChipButton extends StatelessWidget {
  const FollowChipButton({
    super.key,
    required this.followed,
    required this.onTap,
    this.compact = false,
  });

  final bool followed;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (followed) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 14,
            vertical: compact ? 6 : 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(
            followed ? '已关注' : '关注',
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return GradientButton(
      label: '关注',
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 6 : 7,
      ),
      fontSize: compact ? 11 : 12,
    );
  }
}

class SectionUnderlineTitle extends StatelessWidget {
  const SectionUnderlineTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}
