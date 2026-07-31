import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../models/moment_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/comment_list.dart';
import '../widgets/common_widgets.dart';
import '../widgets/content_more_sheet.dart';
import '../widgets/local_image.dart';
import '../widgets/user_profile_nav.dart';

class MomentDetailPage extends StatefulWidget {
  const MomentDetailPage({super.key, required this.item});

  final MomentPost item;

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage> {
  late int _likeCount;
  late int _collectCount;

  String get _key => 'moment_${widget.item.id}';

  @override
  void initState() {
    super.initState();
    _likeCount = widget.item.likes;
    _collectCount = (widget.item.likes ~/ 4) + 8;
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
                    onPressed: () {
                      if (isSelf) {
                        showOwnContentDeleteSheet(
                          context,
                          returnTabIndex: 2,
                          dialogTitle: '删除动态',
                          dialogContent: '确定删除这条动态吗？删除后不可恢复。',
                          successMessage: '动态已删除',
                          onDelete: () => store.hideMoment(widget.item.id),
                        );
                      } else {
                        showContentMoreSheet(
                          context,
                          author: widget.item.author,
                          returnTabIndex: 2,
                          popToRoot: true,
                          blockMessage:
                              '已拉黑 ${widget.item.author}，其动态将不再展示',
                          hideMessage: '已标记不感兴趣，该动态将不再展示',
                          onHideContent: () =>
                              store.hideMoment(widget.item.id),
                        );
                      }
                    },
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.item.category,
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
                        widget.item.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      widget.item.time,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const Text('  ·  ', style: TextStyle(color: AppColors.textMuted)),
                    const Icon(Icons.place_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 2),
                    const Text(
                      '干货分享',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '${widget.item.content}\n\n这是展开后的详细动态内容。大家在约拍的时候，一定要多注意光线和构图，多沟通才能出好片哦！有什么问题可以在评论区交流，喜欢的家人们点个赞支持一下吧！',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.55,
                  ),
                ),
                if (widget.item.images.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ...widget.item.images.map((path) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: LocalCover(
                        path: path,
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).width - 32,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 18),
                CommentList(threadKey: _key, title: '全部评论'),
                const SizedBox(height: 60),
              ],
            ),
          ),
          DetailBottomBar(
            threadKey: _key,
            hint: '写评论...',
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
