import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../models/feed_post.dart';
import '../theme/app_theme.dart';
import 'app_scope.dart';
import 'local_image.dart';
import 'user_profile_nav.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final FeedPost item;
  final VoidCallback onTap;

  IconData get _typeIcon {
    switch (item.type) {
      case '摄影师':
        return Icons.camera_alt_outlined;
      case '模特':
        return Icons.auto_awesome;
      case '化妆师':
        return Icons.brush_outlined;
      default:
        return Icons.image_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = AvatarHelper.resolve(
      AppScope.storeOf(context),
      item.author,
      item.avatar,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                LocalCover(
                  path: item.image,
                  width: double.infinity,
                  height: item.imageHeight,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_typeIcon, size: 10, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          item.type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                              LocalAvatar(path: avatar, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Icon(Icons.favorite_border, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Text(
                        '${item.likes}',
                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
