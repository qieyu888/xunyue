import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../data/mock_data.dart';
import '../models/feed_post.dart';
import '../models/moment_post.dart';
import '../models/need_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/common_widgets.dart';
import '../widgets/content_more_sheet.dart';
import '../widgets/local_image.dart';
import 'moment_detail_page.dart';
import 'need_detail_page.dart';
import 'post_detail_page.dart';

/// 他人个人主页。
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    super.key,
    required this.author,
    this.avatar,
  });

  final String author;
  final String? avatar;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _subTab = 0;

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final profile = MockData.profileFor(
      widget.author,
      avatar: widget.avatar,
    );
    final avatar = AvatarHelper.resolve(
      store,
      widget.author,
      profile.avatar,
    );
    final followed = store.isFollowed(widget.author);
    final works = store.worksForAuthor(widget.author);
    final moments = store.momentsForAuthor(widget.author);
    final needs = store.needsForAuthor(widget.author);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(bottom: 24 + MediaQuery.paddingOf(context).bottom),
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: AppTheme.profileHeaderGradient,
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 4,
                left: 4,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, size: 30, color: Colors.white),
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 4,
                right: 4,
                child: IconButton(
                  onPressed: () {
                    showContentMoreSheet(
                      context,
                      author: widget.author,
                      returnTabIndex: 0,
                      popToRoot: true,
                      blockMessage: '已拉黑 ${widget.author}，其内容将不再展示',
                      hideMessage: '已标记不感兴趣',
                      onHideContent: () async {},
                    );
                  },
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 140, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LocalAvatar(path: avatar, size: 88, borderWidth: 4),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FollowChipButton(
                            followed: followed,
                            onTap: () async {
                              final scope = AppScope.of(context);
                              await store.toggleFollow(widget.author);
                              if (!mounted) return;
                              scope.refresh();
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          profile.nickname,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 16, color: Color(0xFF3B82F6)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${profile.userId}  ·  IP属地: ${profile.city.split(' ').first}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _TagChip(text: profile.role, highlight: true),
                        ...profile.tagList.map((t) => _TagChip(text: t)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.bio,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _Stat(value: '${profile.likes}', label: '获赞与收藏'),
                        const SizedBox(width: 28),
                        _Stat(value: '${profile.following}', label: '关注'),
                        const SizedBox(width: 28),
                        _Stat(value: profile.fans, label: '粉丝'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _SubTab(
                          label: '作品 ${works.length}',
                          active: _subTab == 0,
                          onTap: () => setState(() => _subTab = 0),
                        ),
                        const SizedBox(width: 28),
                        _SubTab(
                          label: '动态 ${moments.length}',
                          active: _subTab == 1,
                          onTap: () => setState(() => _subTab = 1),
                        ),
                        const SizedBox(width: 28),
                        _SubTab(
                          label: '需求 ${needs.length}',
                          active: _subTab == 2,
                          onTap: () => setState(() => _subTab = 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_subTab == 0)
                      _WorksGrid(works: works)
                    else if (_subTab == 1)
                      _MomentsList(moments: moments)
                    else
                      _NeedsList(needs: needs),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text, this.highlight = false});

  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlight ? AppColors.roseLight : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
        border: highlight ? Border.all(color: AppColors.roseBorder) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: highlight ? AppColors.rose : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }
}

class _SubTab extends StatelessWidget {
  const _SubTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? const Color(0xFF111827) : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 28,
            height: 2,
            color: active ? const Color(0xFFFB7185) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _WorksGrid extends StatelessWidget {
  const _WorksGrid({required this.works});

  final List<FeedPost> works;

  @override
  Widget build(BuildContext context) {
    if (works.isEmpty) {
      return const _EmptyHint(text: '暂无作品');
    }
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: works.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final item = works[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PostDetailPage(item: item)),
            );
          },
          child: LocalCover(path: item.image),
        );
      },
    );
  }
}

class _MomentsList extends StatelessWidget {
  const _MomentsList({required this.moments});

  final List<MomentPost> moments;

  @override
  Widget build(BuildContext context) {
    if (moments.isEmpty) {
      return const _EmptyHint(text: '暂无动态');
    }
    return Column(
      children: moments.map((item) {
        final cover = item.images.isNotEmpty ? item.images.first : null;
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MomentDetailPage(item: item)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (cover != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LocalCover(path: cover, width: 64, height: 64),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title.isNotEmpty ? item.title : item.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.time,
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NeedsList extends StatelessWidget {
  const _NeedsList({required this.needs});

  final List<NeedPost> needs;

  @override
  Widget build(BuildContext context) {
    if (needs.isEmpty) {
      return const _EmptyHint(text: '暂无需求');
    }
    return Column(
      children: needs.map((item) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => NeedDetailPage(item: item)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    const Spacer(),
                    Text(
                      item.time,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
