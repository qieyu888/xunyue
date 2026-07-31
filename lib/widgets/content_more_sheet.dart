import 'package:flutter/material.dart';

import '../pages/report_post_page.dart';
import '../theme/app_theme.dart';
import 'app_scope.dart';

/// 内容「更多」：拉黑 / 举报 / 不感兴趣
/// [returnTabIndex] 操作完成后回到的主壳 Tab（0 首页 / 1 寻约 / 2 动态 / 3 我的）
Future<void> showContentMoreSheet(
  BuildContext context, {
  required String author,
  required Future<void> Function() onHideContent,
  int returnTabIndex = 0,
  bool popToRoot = false,
  String blockMessage = '已拉黑，相关内容将不再展示',
  String hideMessage = '已标记不感兴趣',
}) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('拉黑'),
              onTap: () async {
                Navigator.pop(ctx);
                await _blockAndLeave(
                  context,
                  author: author,
                  returnTabIndex: returnTabIndex,
                  popToRoot: popToRoot,
                  message: blockMessage,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('举报'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ReportPostPage(
                      author: author,
                      onHideContent: onHideContent,
                      returnTabIndex: returnTabIndex,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off_outlined),
              title: const Text('不感兴趣'),
              onTap: () async {
                Navigator.pop(ctx);
                await _hideAndLeave(
                  context,
                  onHideContent: onHideContent,
                  returnTabIndex: returnTabIndex,
                  popToRoot: popToRoot,
                  message: hideMessage,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

/// 自己发布的内容「更多」：删除
Future<void> showOwnContentDeleteSheet(
  BuildContext context, {
  required Future<void> Function() onDelete,
  int returnTabIndex = 3,
  bool popToRoot = true,
  String dialogTitle = '删除内容',
  String dialogContent = '确定删除吗？删除后不可恢复。',
  String successMessage = '已删除',
}) {
  return showModalBottomSheet<void>(
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
              onTap: () async {
                Navigator.pop(ctx);
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (dialogCtx) {
                    return AlertDialog(
                      title: Text(dialogTitle),
                      content: Text(dialogContent),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx, false),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx, true),
                          child: const Text(
                            '删除',
                            style: TextStyle(color: AppColors.rose),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (ok != true || !context.mounted) return;

                final scope = AppScope.of(context);
                final messenger = ScaffoldMessenger.of(context);
                await onDelete();
                scope.store.selectMainTab(returnTabIndex);
                scope.refresh();
                if (!context.mounted) return;
                if (popToRoot) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
                messenger.showSnackBar(SnackBar(content: Text(successMessage)));
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _blockAndLeave(
  BuildContext context, {
  required String author,
  required int returnTabIndex,
  required bool popToRoot,
  required String message,
}) async {
  final scope = AppScope.of(context);
  final messenger = ScaffoldMessenger.of(context);
  await scope.store.blockAuthor(author);
  scope.store.selectMainTab(returnTabIndex);
  scope.refresh();
  if (!context.mounted) return;
  if (popToRoot) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

Future<void> _hideAndLeave(
  BuildContext context, {
  required Future<void> Function() onHideContent,
  required int returnTabIndex,
  required bool popToRoot,
  required String message,
}) async {
  final scope = AppScope.of(context);
  final messenger = ScaffoldMessenger.of(context);
  await onHideContent();
  scope.store.selectMainTab(returnTabIndex);
  scope.refresh();
  if (!context.mounted) return;
  if (popToRoot) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  messenger.showSnackBar(SnackBar(content: Text(message)));
}
