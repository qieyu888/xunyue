import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../models/moment_post.dart';
import '../theme/app_theme.dart';
import 'app_scope.dart';
import 'content_more_sheet.dart';
import 'local_image.dart';
import 'user_profile_nav.dart';

class MomentCard extends StatelessWidget {
  const MomentCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final MomentPost item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final cols = item.images.length >= 3
        ? 3
        : item.images.length == 2
            ? 2
            : 1;
    final avatar = AvatarHelper.resolve(
      store,
      item.author,
      item.avatar,
    );
    final commentCount = store.commentsFor('moment_${item.id}').length;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
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
                      LocalAvatar(path: avatar, size: 32),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.author,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            item.time,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showContentMoreSheet(
                      context,
                      author: item.author,
                      returnTabIndex: 2,
                      blockMessage: '已拉黑 ${item.author}，其动态将不再展示',
                      hideMessage: '已标记不感兴趣，该动态将不再展示',
                      onHideContent: () =>
                          AppScope.storeOf(context).hideMoment(item.id),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.more_horiz,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFEA580C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            if (item.images.isNotEmpty) ...[
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = 8.0;
                  final maxW = cols == 1
                      ? constraints.maxWidth * 0.66
                      : constraints.maxWidth;
                  final itemWidth = (maxW - gap * (cols - 1)) / cols;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: maxW,
                      child: Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: item.images.map((path) {
                          return LocalCover(
                            path: path,
                            width: itemWidth,
                            height: itemWidth,
                            borderRadius: BorderRadius.circular(12),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 10,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 3),
                      Text(
                        '经验分享',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.favorite_border,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${item.likes}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 14),
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '$commentCount',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
