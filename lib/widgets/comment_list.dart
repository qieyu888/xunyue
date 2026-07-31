import 'package:flutter/material.dart';

import '../data/avatar_helper.dart';
import '../models/comment_item.dart';
import '../theme/app_theme.dart';
import 'app_scope.dart';
import 'local_image.dart';
import 'user_profile_nav.dart';

/// 内联发布评论（无弹窗）；返回是否成功。
Future<bool> submitComment(
  BuildContext context, {
  required String threadKey,
  required String text,
  String? replyTo,
  String successMessage = '评论已发布',
}) async {
  final trimmed = text.trim();
  if (trimmed.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请输入评论内容')),
    );
    return false;
  }
  final scope = AppScope.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    await scope.store.addComment(threadKey, trimmed, replyTo: replyTo);
    FocusManager.instance.primaryFocus?.unfocus();
    scope.refresh();
    messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    return true;
  } catch (_) {
    messenger.showSnackBar(
      const SnackBar(content: Text('评论发布失败，请重试')),
    );
    return false;
  }
}

class CommentList extends StatelessWidget {
  const CommentList({
    super.key,
    required this.threadKey,
    this.title,
  });

  final String threadKey;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final store = AppScope.storeOf(context);
    final me = store.profile.nickname;
    final list = store.commentsFor(threadKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '共 ${list.length} 条评论',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                '还没有评论，来说两句吧',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ),
          )
        else
          ...list.map((comment) {
            final avatar = AvatarHelper.resolve(
              store,
              comment.author,
              comment.avatar,
            );
            final isMine = comment.author == me;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      openUserProfile(
                        context,
                        author: comment.author,
                        avatar: comment.avatar,
                      );
                    },
                    child: LocalAvatar(path: avatar, size: 32),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            openUserProfile(
                              context,
                              author: comment.author,
                              avatar: comment.avatar,
                            );
                          },
                          child: Text(
                            comment.author,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (comment.replyTo != null) ...[
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '回复 ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textMuted,
                                    height: 1.4,
                                  ),
                                ),
                                TextSpan(
                                  text: '@${comment.replyTo} ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF2563EB),
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: comment.content,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else
                          Text(
                            comment.content,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              comment.time,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                            if (isMine) ...[
                              const SizedBox(width: 14),
                              GestureDetector(
                                onTap: () => _confirmDelete(context, comment),
                                child: const Text(
                                  '删除',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.rose,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, CommentItem comment) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('删除评论'),
          content: const Text('确定删除这条评论吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
    if (ok != true || !context.mounted) return;
    final scope = AppScope.of(context);
    await scope.store.deleteComment(threadKey, comment.id);
    scope.refresh();
  }
}

class DetailBottomBar extends StatefulWidget {
  const DetailBottomBar({
    super.key,
    required this.threadKey,
    required this.hint,
    required this.liked,
    required this.likeCount,
    required this.collected,
    required this.collectCount,
    required this.onLike,
    required this.onCollect,
    this.successMessage = '评论已发布',
  });

  final String threadKey;
  final String hint;
  final bool liked;
  final int likeCount;
  final bool collected;
  final int collectCount;
  final VoidCallback onLike;
  final VoidCallback onCollect;
  final String successMessage;

  @override
  State<DetailBottomBar> createState() => _DetailBottomBarState();
}

class _DetailBottomBarState extends State<DetailBottomBar> {
  final _controller = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final ok = await submitComment(
      context,
      threadKey: widget.threadKey,
      text: _controller.text,
      successMessage: widget.successMessage,
    );
    if (!mounted) return;
    if (ok) {
      _controller.clear();
    }
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        14,
        10,
        14,
        MediaQuery.paddingOf(context).bottom + 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !_submitting,
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submit(),
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _submitting ? null : _submit,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.rose,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(_submitting ? '发送中' : '发送'),
          ),
          const SizedBox(width: 8),
          _Action(
            icon: widget.liked ? Icons.favorite : Icons.favorite_border,
            color: widget.liked ? AppColors.rose : AppColors.textSecondary,
            count: widget.likeCount,
            onTap: widget.onLike,
          ),
          const SizedBox(width: 16),
          _Action(
            icon: widget.collected ? Icons.star : Icons.star_border,
            color: widget.collected ? AppColors.orange : AppColors.textSecondary,
            count: widget.collectCount,
            onTap: widget.onCollect,
          ),
        ],
      ),
    );
  }
}

/// 留言板内联输入（无弹窗）。
class InlineCommentField extends StatefulWidget {
  const InlineCommentField({
    super.key,
    required this.threadKey,
    this.hint = '写留言...',
    this.successMessage = '留言已发布',
  });

  final String threadKey;
  final String hint;
  final String successMessage;

  @override
  State<InlineCommentField> createState() => _InlineCommentFieldState();
}

class _InlineCommentFieldState extends State<InlineCommentField> {
  final _controller = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final ok = await submitComment(
      context,
      threadKey: widget.threadKey,
      text: _controller.text,
      successMessage: widget.successMessage,
    );
    if (!mounted) return;
    if (ok) {
      _controller.clear();
    }
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: !_submitting,
            maxLines: 3,
            minLines: 1,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: widget.hint,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: _submitting ? null : _submit,
          child: Text(_submitting ? '发送中' : '发送'),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
