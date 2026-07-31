import 'package:flutter/material.dart';

import '../data/app_copy.dart';
import '../data/app_images.dart';
import '../theme/app_theme.dart';

/// Logo + 名称 + 宣传语
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.logoSize = 88,
    this.nameSize = 28,
    this.sloganSize = 14,
    this.spacing = 16,
    this.showLogo = true,
    this.showName = true,
    this.showSlogan = true,
  });

  final double logoSize;
  final double nameSize;
  final double sloganSize;
  final double spacing;
  final bool showLogo;
  final bool showName;
  final bool showSlogan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo)
          ClipRRect(
            borderRadius: BorderRadius.circular(logoSize * 0.22),
            child: Image.asset(
              AppImages.logo,
              width: logoSize,
              height: logoSize,
              fit: BoxFit.cover,
            ),
          ),
        if (showLogo && (showName || showSlogan)) SizedBox(height: spacing),
        if (showName)
          Text(
            AppCopy.appName,
            style: TextStyle(
              fontSize: nameSize,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
        if (showName && showSlogan) const SizedBox(height: 8),
        if (showSlogan)
          Text(
            AppCopy.slogan,
            style: TextStyle(
              fontSize: sloganSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
      ],
    );
  }
}
