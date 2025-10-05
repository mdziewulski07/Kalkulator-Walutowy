import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart' show Settings;

class ColorTokens {
  const ColorTokens({
    required this.background,
    required this.surface1,
    required this.surface2,
    required this.tile,
    required this.tilePressed,
    required this.divider,
    required this.accent,
    required this.accentMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.icon,
  });

  final Color background;
  final Color surface1;
  final Color surface2;
  final Color tile;
  final Color tilePressed;
  final Color divider;
  final Color accent;
  final Color accentMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color icon;
}

class TypographyTokens {
  TypographyTokens(this.textTheme);

  final TextTheme textTheme;

  TextStyle get amountLarge =>
      textTheme.displayLarge!.copyWith(fontSize: 44, fontWeight: FontWeight.w600, height: 52 / 44, fontFeatures: const [FontFeature.tabularFigures()]);
  TextStyle get currencyLabel =>
      textTheme.titleLarge!.copyWith(fontSize: 24, fontWeight: FontWeight.w500, height: 28 / 24, fontFeatures: const [FontFeature.tabularFigures()]);
  TextStyle get keyLabel =>
      textTheme.titleMedium!.copyWith(fontSize: 22, fontWeight: FontWeight.w500, height: 26 / 22, fontFeatures: const [FontFeature.tabularFigures()]);
  TextStyle get meta => textTheme.labelSmall!.copyWith(fontSize: 13, fontWeight: FontWeight.w400, height: 16 / 13);
}

class SpacingTokens {
  static const double grid = 8;
  static const double gutter = 20;
  static const BorderRadius radius8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radius12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radius20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radius24 = BorderRadius.all(Radius.circular(24));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

class CurrencyThemeData {
  CurrencyThemeData({required this.lightColors, required this.darkColors, required this.typography});

  final ColorTokens lightColors;
  final ColorTokens darkColors;
  final TypographyTokens typography;

  factory CurrencyThemeData.fromSettings(Settings _) {
    final textTheme = TypographyTokens(Typography.material2021());
    return CurrencyThemeData(
      lightColors: const ColorTokens(
        background: Color(0xFFF7F8FA),
        surface1: Color(0xFFFFFFFF),
        surface2: Color(0xFFF3F4F6),
        tile: Color(0xFFF6F7F9),
        tilePressed: Color(0xFFECEEF1),
        divider: Color(0xFFE2E5EA),
        accent: Color(0xFF111111),
        accentMuted: Color(0xFF6B7280),
        textPrimary: Color(0xFF0B0C0E),
        textSecondary: Color(0xFF6B7280),
        icon: Color(0xFF111111),
      ),
      darkColors: const ColorTokens(
        background: Color(0xFF09121E),
        surface1: Color(0xFF0F1A23),
        surface2: Color(0xFF101E28),
        tile: Color(0xFF0E1821),
        tilePressed: Color(0xFF13222C),
        divider: Color(0xFF1A2A33),
        accent: Color(0xFF5FDBD8),
        accentMuted: Color(0xFF54BEBE),
        textPrimary: Color(0xFFEAE9EA),
        textSecondary: Color(0xFF93A8B3),
        icon: Color(0xFF5FDBD8),
      ),
      typography: textTheme,
    );
  }
}
