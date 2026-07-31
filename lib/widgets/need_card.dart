import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../models/need_post.dart';
import '../theme/app_theme.dart';
import 'app_scope.dart';
import 'local_image.dart';
import 'user_profile_nav.dart';

class NeedCard extends StatelessWidget {
  const NeedCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final NeedPost item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cols = item.images.length >= 3
        ? 3
        : item.images.length == 2
            ? 2
            : 1;
    final avatar = AvatarHelper.resolve(
      AppScope.storeOf(context),
      item.author,
      item.avatar,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      openUserProfile(
                        context,
                        author: item.author,
                        avatar: item.avatar,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        LocalAvatar(path: avatar, size: 40),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.author,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.roseLight,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.roseBorder),
                  ),
                  child: Text(
                    item.type,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.rose,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              item.content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.5,
              ),
            ),
            if (item.images.isNotEmpty) ...[
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = 8.0;
                  final itemWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;
                  final imageHeight = cols == 1
                      ? 180.0
                      : cols == 2
                          ? 140.0
                          : 120.0;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: item.images.map((path) {
                      return LocalCover(
                        path: path,
                        width: itemWidth,
                        height: imageHeight,
                        borderRadius: BorderRadius.circular(10),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
