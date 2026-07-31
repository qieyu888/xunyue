import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/brand_mark.dart';
import 'login_page.dart';
import 'main_shell.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _enter;
  late final AnimationController _pulse;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _logoOpacity = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(
        parent: _enter,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _textOpacity = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _enter,
        curve: const Interval(0.35, 0.9, curve: Curves.easeOutCubic),
      ),
    );
    _glow = Tween<double>(begin: 0.18, end: 0.34).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );

    _enter.forward();
    unawaited(_goNext());
  }

  Future<void> _goNext() async {
    await Future<void>.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    final loggedIn = AppScope.storeOf(context).isLoggedIn;
    final next = loggedIn ? const MainShell() : const LoginPage();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => next,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 420),
      ),
    );
  }

  @override
  void dispose() {
    _enter.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_enter, _pulse]),
        builder: (context, _) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFF7ED),
                  Color.lerp(
                    const Color(0xFFFDF2F8),
                    const Color(0xFFFCE7F3),
                    _glow.value,
                  )!,
                  Colors.white,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.pink.withValues(alpha: _glow.value),
                                blurRadius: 28,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const BrandMark(
                            logoSize: 96,
                            showName: false,
                            showSlogan: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: const BrandMark(
                          showLogo: false,
                          nameSize: 30,
                          sloganSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
