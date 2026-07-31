import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

bool isAssetImagePath(String path) => path.startsWith('assets/');

class LocalAvatar extends StatelessWidget {
  const LocalAvatar({
    super.key,
    required this.path,
    this.size = 32,
    this.borderWidth = 0,
    this.borderColor = Colors.white,
  });

  final String path;
  final double size;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final innerSize = (size - borderWidth * 2).clamp(0.0, size);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: borderWidth > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: ClipOval(
        child: SizedBox(
          width: innerSize,
          height: innerSize,
          child: _LocalImage(
            path: path,
            fit: BoxFit.cover,
            width: innerSize,
            height: innerSize,
            placeholder: Container(
              width: innerSize,
              height: innerSize,
              color: AppColors.roseLight,
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                size: innerSize * 0.5,
                color: AppColors.rose,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LocalCover extends StatelessWidget {
  const LocalCover({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = SizedBox(
      width: width,
      height: height,
      child: _LocalImage(
        path: path,
        fit: fit,
        width: width,
        height: height,
        placeholder: Container(
          width: width,
          height: height,
          color: const Color(0xFFF3F4F6),
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, color: AppColors.textMuted),
        ),
      ),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class _LocalImage extends StatelessWidget {
  const _LocalImage({
    required this.path,
    required this.fit,
    required this.placeholder,
    this.width,
    this.height,
  });

  final String path;
  final BoxFit fit;
  final Widget placeholder;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return placeholder;

    if (isAssetImagePath(path)) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    final file = File(path);
    if (!file.existsSync()) return placeholder;

    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}
