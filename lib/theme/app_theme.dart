import 'package:flutter/material.dart';

class AppColors {
  static const Color orange = Color(0xFFFB923C);
  static const Color pink = Color(0xFFEC4899);
  static const Color rose = Color(0xFFF43F5E);
  static const Color roseLight = Color(0xFFFFF1F2);
  static const Color roseBorder = Color(0xFFFFE4E6);
  static const Color bg = Color(0xFFF9FAFB);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFF3F4F6);
  static const Color card = Colors.white;
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.rose,
        primary: AppColors.rose,
        secondary: AppColors.orange,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      dividerColor: AppColors.border,
      splashFactory: InkRipple.splashFactory,
    );
  }

  static const LinearGradient brandGradient = LinearGradient(
    colors: [AppColors.orange, AppColors.pink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFFFFEDD5), Color(0xFFFCE7F3)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient profileHeaderGradient = LinearGradient(
    colors: [Color(0xFFFDBA74), Color(0xFFFB7185), Color(0xFFEC4899)],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}
