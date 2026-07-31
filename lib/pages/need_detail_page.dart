import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../models/need_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/comment_list.dart';
import '../widgets/common_widgets.dart';
import '../widgets/content_more_sheet.dart';
import '../widgets/local_image.dart';
import '../widgets/user_profile_nav.dart';

class NeedDetailPage extends StatefulWidget {
  const NeedDetailPage({super.key, required this.item});

  final NeedPost item;

  @override
  State<NeedDetailPage> createState() => _NeedDetailPageState();
}

class _NeedDetailPageState extends State<NeedDetailPage> {
  void _showMore() {
    final store = AppScope.storeOf(context);
    final me = store.profile.nickname;
    final isSelf =
        widget.item.author == me || widget.item.author == 'Nana_酱';

    if (isSelf) {
      _showDeleteSheet();
    } else {
      showContentMoreSheet(
        context,
        author: widget.item.author,
        returnTabIndex: 1,
        popToRoot: true,
        blockMessage: '已拉黑 ${widget.item.author}，其需求将不再展示',
        hideMessage: '已标记不感兴趣，该需求将不再展示',
        onHideContent: () => store.hideNeed(widget.item.id),
      );
    }
  }

  void _showDeleteSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.rose),
                title: const Text(
                  '删除',
                  style: TextStyle(color: AppColors.rose),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('删除需求'),
          content: const Text('确定删除这条需求吗？删除后不可恢复。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                '删除',
                style: TextStyle(color: AppColors.rose),
              ),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;

    final scope = AppScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await scope.store.deleteNeed(widget.item.id);
    scope.store.selectMainTab(1);
    scope.refresh();
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      const SnackBar(content: Text('需求已删除')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final me = store.profile.nickname;
    final followed = store.isFollowed(widget.item.author);
    final isSelf =
        widget.item.author == me || widget.item.author == 'Nana_酱';
    final authorAvatar = AvatarHelper.resolve(
      store,
      widget.item.author,
      widget.item.avatar,
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 4, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left, size: 30),
                  ),
                  const Expanded(
                    child: Text(
                      '需求详情',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showMore,
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
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
                                  author: widget.item.author,
                                  avatar: widget.item.avatar,
                                );
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                children: [
                                  LocalAvatar(path: authorAvatar, size: 48),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.item.author,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.item.time,
                                          style: const TextStyle(
                                            fontSize: 12,
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
                          if (!isSelf)
                            FollowChipButton(
                              followed: followed,
                              compact: true,
                              onTap: () async {
                                final scope = AppScope.of(context);
                                await store.toggleFollow(widget.item.author);
                                if (!mounted) return;
                                scope.refresh();
                                setState(() {});
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.brandGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.item.type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...widget.item.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.item.content,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.55,
                        ),
                      ),
                      if (widget.item.images.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        ...widget.item.images.map((path) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: LocalCover(
                              path: path,
                              width: double.infinity,
                              height: 220,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CommentList(
                        threadKey: 'need_${widget.item.id}',
                        title: '留言板',
                      ),
                      const SizedBox(height: 12),
                      InlineCommentField(
                        threadKey: 'need_${widget.item.id}',
                        hint: '写留言...',
                        successMessage: '留言已发布',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
