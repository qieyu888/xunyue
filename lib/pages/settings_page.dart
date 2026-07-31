import 'package:flutter/material.dart';

import '../data/app_copy.dart';
import '../data/app_images.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import 'feedback_page.dart';
import 'settings_doc_page.dart';
import 'splash_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('设置'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _SettingsGroup(
            children: [
              _SettingsTile(
                title: '帮助与反馈',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FeedbackPage(title: '帮助与反馈'),
                    ),
                  );
                },
              ),
              _SettingsTile(
                title: '我要投诉',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FeedbackPage(
                        title: '我要投诉',
                        isComplaint: true,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsGroup(
            children: [
              _SettingsTile(
                title: '用户须知',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SettingsDocPage(
                        title: '用户须知',
                        paragraphs: SettingsTexts.userNotice,
                      ),
                    ),
                  );
                },
              ),
              _SettingsTile(
                title: '隐私协议',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SettingsDocPage(
                        title: '隐私协议',
                        paragraphs: SettingsTexts.privacy,
                      ),
                    ),
                  );
                },
              ),
              _SettingsTile(
                title: '关于我们',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SettingsDocPage(
                        title: '关于我们',
                        paragraphs: SettingsTexts.aboutUs,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsGroup(
            children: [
              _SettingsTile(
                title: '注销账号',
                titleColor: AppColors.rose,
                onTap: () => _confirmDeleteAccount(context),
              ),
              _SettingsTile(
                title: '退出账号',
                showDivider: false,
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  AppImages.logo,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '${AppCopy.appName} ${AppCopy.version}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('退出账号'),
        content: const Text('退出后将清除本地点赞、收藏与关注状态，个人资料仍保留在本机。确定退出吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('退出'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final scope = AppScope.of(context);
    await scope.store.logout();
    scope.refresh();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const SplashPage()),
      (_) => false,
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('注销账号'),
        content: const Text(
          '注销将清空本机个人资料、已发布需求以及全部互动记录，且不可恢复。确定继续吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.rose),
            child: const Text('确认注销'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final scope = AppScope.of(context);
    await scope.store.deleteAccount();
    scope.refresh();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const SplashPage()),
      (_) => false,
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.onTap,
    this.titleColor,
    this.showDivider = true,
  });

  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: titleColor ?? AppColors.textPrimary,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
      ],
    );
  }
}
