import 'package:flutter/material.dart';

class AppColorTokens {
  const AppColorTokens({
    required this.backgroundPrimary,
    required this.surfaceElev1,
    required this.surfaceElev2,
    required this.tileDefault,
    required this.tilePressed,
    required this.divider,
    required this.accentPrimary,
    required this.accentMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.icon,
    required this.equalButtonText,
  });

  final Color backgroundPrimary;
  final Color surfaceElev1;
  final Color surfaceElev2;
  final Color tileDefault;
  final Color tilePressed;
  final Color divider;
  final Color accentPrimary;
  final Color accentMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color icon;
  final Color equalButtonText;
}

class AppThemeTokens {
  const AppThemeTokens({
    required this.name,
    required this.colors,
    required this.brightness,
  });

  final String name;
  final AppColorTokens colors;
  final Brightness brightness;
}

class AppTypographyTokens {
  const AppTypographyTokens({
    required this.amountLarge,
    required this.currencyLabel,
    required this.keyLabel,
    required this.meta,
  });

  final TextStyle amountLarge;
  final TextStyle currencyLabel;
  final TextStyle keyLabel;
  final TextStyle meta;
}

class AppSpacing {
  static const double grid = 8;
  static const double gutter = 20;
  static const double radius8 = 8;
  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radius20 = 20;
  static const double radius24 = 24;
  static const double radiusPill = 999;
}

class AppThemes {
  static final light = AppThemeTokens(
    name: 'light-mono',
    brightness: Brightness.light,
    colors: AppColorTokens(
      backgroundPrimary: const Color(0xFFF7F8FA),
      surfaceElev1: const Color(0xFFFFFFFF),
      surfaceElev2: const Color(0xFFF3F4F6),
      tileDefault: const Color(0xFFF6F7F9),
      tilePressed: const Color(0xFFECEEF1),
      divider: const Color(0xFFE2E5EA),
      accentPrimary: const Color(0xFF111111),
      accentMuted: const Color(0xFF6B7280),
      textPrimary: const Color(0xFF0B0C0E),
      textSecondary: const Color(0xFF6B7280),
      icon: const Color(0xFF111111),
      equalButtonText: Colors.white,
    ),
  );

  static final dark = AppThemeTokens(
    name: 'dark-aqua',
    brightness: Brightness.dark,
    colors: AppColorTokens(
      backgroundPrimary: const Color(0xFF09121E),
      surfaceElev1: const Color(0xFF0F1A23),
      surfaceElev2: const Color(0xFF101E28),
      tileDefault: const Color(0xFF0E1821),
      tilePressed: const Color(0xFF13222C),
      divider: const Color(0xFF1A2A33),
      accentPrimary: const Color(0xFF5FDBD8),
      accentMuted: const Color(0xFF54BEBE),
      textPrimary: const Color(0xFFEAE9EA),
      textSecondary: const Color(0xFF93A8B3),
      icon: const Color(0xFF5FDBD8),
      equalButtonText: const Color(0xFF0A1418),
    ),
  );
}

AppTypographyTokens buildTypography(Color textPrimary, Color textSecondary) {
  const fontFamily = 'Inter';
  return AppTypographyTokens(
    amountLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 44,
      height: 52 / 44,
      letterSpacing: -0.4,
      color: textPrimary,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    currencyLabel: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 24,
      height: 28 / 24,
      letterSpacing: -0.2,
      color: textPrimary,
    ),
    keyLabel: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 22,
      height: 26 / 22,
      color: textPrimary,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    meta: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 13,
      height: 16 / 13,
      color: textSecondary,
    ),
  );
}
