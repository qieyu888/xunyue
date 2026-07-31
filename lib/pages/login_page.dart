import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/brand_mark.dart';
import 'main_shell.dart';
import 'settings_doc_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  bool _agreed = false;

  late final TapGestureRecognizer _noticeRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _noticeRecognizer = TapGestureRecognizer()..onTap = _openUserNotice;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _openPrivacy;
  }

  @override
  void dispose() {
    _noticeRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  void _openUserNotice() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SettingsDocPage(
          title: '用户须知',
          paragraphs: SettingsTexts.userNotice,
        ),
      ),
    );
  }

  void _openPrivacy() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SettingsDocPage(
          title: '隐私协议',
          paragraphs: SettingsTexts.privacy,
        ),
      ),
    );
  }

  Future<void> _onLoginTap() async {
    if (_loading) return;
    if (!_agreed) {
      await _showAgreeDialog();
      return;
    }
    await _enterApp();
  }

  Future<void> _showAgreeDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text(
            '温馨提示',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                '请先阅读',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                  _openUserNotice();
                },
                child: const Text(
                  '《用户须知》',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.rose,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Text(
                '和',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                  _openPrivacy();
                },
                child: const Text(
                  '《隐私协议》',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: AppColors.rose,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(
                '不同意',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                '同意',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      setState(() => _agreed = true);
      await _enterApp();
    }
  }

  Future<void> _enterApp() async {
    if (_loading) return;
    setState(() => _loading = true);
    final scope = AppScope.of(context);
    await scope.store.login();
    scope.refresh();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const BrandMark(logoSize: 100, nameSize: 30, sloganSize: 15),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppTheme.brandGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _loading ? null : _onLoginTap,
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                '登录',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 4,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      side: const BorderSide(color: AppColors.textMuted),
                      activeColor: AppColors.rose,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            height: 1.45,
                          ),
                          children: [
                            const TextSpan(text: '登录即表示同意'),
                            TextSpan(
                              text: '隐私协议',
                              style: const TextStyle(
                                color: AppColors.rose,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: _privacyRecognizer,
                            ),
                            const TextSpan(text: '和'),
                            TextSpan(
                              text: '用户须知',
                              style: const TextStyle(
                                color: AppColors.rose,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: _noticeRecognizer,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
