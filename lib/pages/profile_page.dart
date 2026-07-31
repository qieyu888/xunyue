import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../models/feed_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/feed_card.dart';
import '../widgets/local_image.dart';
import 'edit_profile_page.dart';
import 'moment_detail_page.dart';
import 'post_detail_page.dart';
import 'profile_interactions_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _subTab = 0;

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final profile = store.profile;
    final works = store.visibleProfileWorks;
    final favorites = store.favorites;

    return ColoredBox(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.only(
          bottom: 100 + MediaQuery.paddingOf(context).bottom,
        ),
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
                top: MediaQuery.paddingOf(context).top + 8,
                right: 12,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                  ),
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
                        LocalAvatar(
                          path: profile.avatar,
                          size: 88,
                          borderWidth: 4,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ElevatedButton(
                            onPressed: () async {
                              final updated = await Navigator.of(context)
                                  .push<bool>(
                                    MaterialPageRoute(
                                      builder: (_) => const EditProfilePage(),
                                    ),
                                  );
                              if (updated == true && mounted) {
                                setState(() {});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF111827),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: const Text(
                              '编辑资料',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: Color(0xFF3B82F6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${profile.userId}  ·  IP属地: ${profile.city.split(' ').first}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
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
                        _Stat(
                          value: '${store.likedAndCollectedCount}',
                          label: '获赞与收藏',
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ProfileInteractionsPage(),
                              ),
                            );
                            if (mounted) setState(() {});
                          },
                        ),
                        const SizedBox(width: 28),
                        _Stat(
                          value: '${store.followedAuthors.length}',
                          label: '关注',
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ProfileRelationsPage(
                                  type: ProfileRelationType.following,
                                ),
                              ),
                            );
                            if (mounted) setState(() {});
                          },
                        ),
                        const SizedBox(width: 28),
                        _Stat(
                          value: '0',
                          label: '粉丝',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ProfileRelationsPage(
                                  type: ProfileRelationType.fans,
                                ),
                              ),
                            );
                          },
                        ),
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
                          label: '收藏 ${favorites.length}',
                          active: _subTab == 1,
                          onTap: () => setState(() => _subTab = 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_subTab == 0)
                      _WorksGrid(works: works)
                    else if (favorites.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Text(
                            '暂无收藏，去首页点亮星标吧',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      )
                    else
                      _FavoritesMasonry(items: favorites),
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
  const _Stat({required this.value, required this.label, required this.onTap});

  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label $value',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Column(
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
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

class _FavoritesMasonry extends StatelessWidget {
  const _FavoritesMasonry({required this.items});

  final List<FavoriteEntry> items;

  void _openFavorite(BuildContext context, FavoriteEntry entry) {
    if (entry.moment != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MomentDetailPage(item: entry.moment!),
        ),
      );
      return;
    }
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PostDetailPage(item: entry.post)));
  }

  @override
  Widget build(BuildContext context) {
    final left = <FavoriteEntry>[];
    final right = <FavoriteEntry>[];
    for (var i = 0; i < items.length; i++) {
      final entry = FavoriteEntry(
        collectKey: items[i].collectKey,
        moment: items[i].moment,
        post: items[i].post.copyWith(imageHeight: i.isEven ? 150 : 180),
      );
      if (i.isEven) {
        left.add(entry);
      } else {
        right.add(entry);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: left
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8, right: 4),
                    child: FeedCard(
                      item: entry.post,
                      onTap: () => _openFavorite(context, entry),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: Column(
            children: right
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: FeedCard(
                      item: entry.post,
                      onTap: () => _openFavorite(context, entry),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
