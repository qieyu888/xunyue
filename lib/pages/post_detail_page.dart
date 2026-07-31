import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../models/feed_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/comment_list.dart';
import '../widgets/common_widgets.dart';
import '../widgets/content_more_sheet.dart';
import '../widgets/local_image.dart';
import '../widgets/user_profile_nav.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.item});

  final FeedPost item;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late int _likeCount;
  late int _collectCount;

  String get _key => 'feed_${widget.item.id}';

  @override
  void initState() {
    super.initState();
    _likeCount = widget.item.likes;
    _collectCount = (widget.item.likes ~/ 3) + 12;
  }

  void _showMoreSheet() {
    final store = AppScope.storeOf(context);
    final me = store.profile.nickname;
    final isSelf =
        widget.item.author == me || widget.item.author == 'Nana_酱';

    if (isSelf) {
      showOwnContentDeleteSheet(
        context,
        returnTabIndex: 3,
        dialogTitle: '删除作品',
        dialogContent: '确定删除这条作品吗？删除后不可恢复。',
        successMessage: '作品已删除',
        onDelete: () => store.hideFeed(widget.item.id),
      );
    } else {
      showContentMoreSheet(
        context,
        author: widget.item.author,
        returnTabIndex: 0,
        popToRoot: true,
        blockMessage: '已拉黑 ${widget.item.author}，其内容将不再在首页展示',
        hideMessage: '已标记不感兴趣，该内容将不再在首页展示',
        onHideContent: () => store.hideFeed(widget.item.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final me = store.profile.nickname;
    final liked = store.isLiked(_key);
    final collected = store.isCollected(_key);
    final followed = store.isFollowed(widget.item.author);
    final isSelf = widget.item.author == me || widget.item.author == 'Nana_酱';
    final authorAvatar = AvatarHelper.resolve(
      store,
      widget.item.author,
      widget.item.avatar,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(4, 4, 8, 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left, size: 30),
                  ),
                  GestureDetector(
                    onTap: () {
                      openUserProfile(
                        context,
                        author: widget.item.author,
                        avatar: widget.item.avatar,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        LocalAvatar(path: authorAvatar, size: 32),
                        const SizedBox(width: 8),
                        Text(
                          widget.item.author,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!isSelf)
                    FollowChipButton(
                      followed: followed,
                      onTap: () async {
                        final scope = AppScope.of(context);
                        await store.toggleFollow(widget.item.author);
                        if (!mounted) return;
                        scope.refresh();
                        setState(() {});
                      },
                    ),
                  IconButton(
                    onPressed: _showMoreSheet,
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: LocalCover(path: widget.item.image),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.item.description ??
                            '这是一段详细的图文描述内容，分享了拍摄的心得、使用的设备以及后期的思路。希望大家喜欢这次的分享！\n\n📷 设备：Sony A7M4 + 50mm F1.2\n🎨 后期：Lightroom\n\n#约拍 #摄影日常 #人像摄影 #我的摄影日记',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF374151),
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        '发布于 刚刚',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 18),
                      CommentList(threadKey: _key),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DetailBottomBar(
            threadKey: _key,
            hint: '说点什么...',
            liked: liked,
            likeCount: liked ? _likeCount + 1 : _likeCount,
            collected: collected,
            collectCount: collected ? _collectCount + 1 : _collectCount,
            onLike: () async {
              final scope = AppScope.of(context);
              await store.toggleLike(_key);
              if (!mounted) return;
              scope.refresh();
              setState(() {});
            },
            onCollect: () async {
              final scope = AppScope.of(context);
              await store.toggleCollect(_key);
              if (!mounted) return;
              scope.refresh();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
