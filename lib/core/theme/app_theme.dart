import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF0B132B);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF16213E);
  static const Color primary = Color(0xFF0D9488);
  static const Color warn = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color textLight = Color(0xFF0F172A);
  static const Color textDark = Color(0xFFF8FAFC);
  static const Color secondaryLight = Color(0xFF475569);
  static const Color secondaryDark = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF1E293B);
}

abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
}

abstract final class AppRadius {
  static const double card = 12;
  static const double pill = 24;
}

abstract final class AppTheme {
  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primary,
      secondary:
          isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      onSurface: isDark ? AppColors.textDark : AppColors.textLight,
      error: AppColors.danger,
      outline: isDark ? AppColors.borderDark : AppColors.borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.bgDark : AppColors.bgLight,
      fontFamily: 'Inter',
    );
  }
}

TextStyle mono(
  double size, {
  Color? color,
  FontWeight fontWeight = FontWeight.w500,
  double height = 1.2,
}) {
  return TextStyle(
    fontFamily: 'JetBrainsMono',
    fontFamilyFallback: const ['monospace'],
    fontSize: size,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: 0,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

