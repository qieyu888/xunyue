import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/local_image.dart';
import 'moment_detail_page.dart';
import 'post_detail_page.dart';
import 'user_profile_page.dart';

class ProfileInteractionsPage extends StatefulWidget {
  const ProfileInteractionsPage({super.key});

  @override
  State<ProfileInteractionsPage> createState() =>
      _ProfileInteractionsPageState();
}

class _ProfileInteractionsPageState extends State<ProfileInteractionsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final liked = store.likedEntries;
    final favorites = store.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('获赞与收藏 ${liked.length + favorites.length}'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.rose,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: [
            Tab(text: '点赞 ${liked.length}'),
            Tab(text: '收藏 ${favorites.length}'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _InteractionList(
            emptyText: '暂无点赞内容',
            items: liked
                .map(
                  (entry) => _InteractionItem(
                    title: entry.post.title,
                    author: entry.post.author,
                    image: entry.post.image,
                    onTap: () => _openLiked(context, entry),
                  ),
                )
                .toList(),
          ),
          _InteractionList(
            emptyText: '暂无收藏内容',
            items: favorites
                .map(
                  (entry) => _InteractionItem(
                    title: entry.post.title,
                    author: entry.post.author,
                    image: entry.post.image,
                    onTap: () => _openFavorite(context, entry),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _openLiked(BuildContext context, LikedEntry entry) {
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
}

class _InteractionList extends StatelessWidget {
  const _InteractionList({required this.emptyText, required this.items});

  final String emptyText;
  final List<_InteractionItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(icon: Icons.favorite_border, text: emptyText);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, index) => items[index],
    );
  }
}

class _InteractionItem extends StatelessWidget {
  const _InteractionItem({
    required this.title,
    required this.author,
    required this.image,
    required this.onTap,
  });

  final String title;
  final String author;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: LocalCover(path: image, width: 72, height: 72),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

enum ProfileRelationType { following, fans }

class ProfileRelationsPage extends StatefulWidget {
  const ProfileRelationsPage({super.key, required this.type});

  final ProfileRelationType type;

  @override
  State<ProfileRelationsPage> createState() => _ProfileRelationsPageState();
}

class _ProfileRelationsPageState extends State<ProfileRelationsPage> {
  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final isFollowing = widget.type == ProfileRelationType.following;
    final authors = isFollowing
        ? store.followedAuthors.toList(growable: false)
        : const <String>[];

    return Scaffold(
      appBar: AppBar(
        title: Text('${isFollowing ? '关注' : '粉丝'} ${authors.length}'),
      ),
      body: authors.isEmpty
          ? _EmptyState(
              icon: isFollowing
                  ? Icons.person_add_alt_1_outlined
                  : Icons.people_outline,
              text: isFollowing ? '暂无关注用户' : '暂无粉丝',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: authors.length,
              separatorBuilder: (_, _) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final author = authors[index];
                final profile = MockData.profileFor(author);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => UserProfilePage(
                          author: author,
                          avatar: profile.avatar,
                        ),
                      ),
                    );
                  },
                  leading: LocalAvatar(path: profile.avatar, size: 48),
                  title: Text(
                    profile.nickname,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${profile.role} · ${profile.city}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: OutlinedButton(
                    onPressed: () async {
                      final scope = AppScope.of(context);
                      await store.toggleFollow(author);
                      if (!mounted) return;
                      scope.refresh();
                      setState(() {});
                    },
                    child: const Text('已关注'),
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
