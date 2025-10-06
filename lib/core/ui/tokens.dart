import 'dart:ui';

import 'package:flutter/material.dart';

class PaletteLight {
  static const Color bgPrimary = Color(0xFFF7F8FA);
  static const Color surfaceElev1 = Color(0xFFFFFFFF);
  static const Color surfaceElev2 = Color(0xFFF3F4F6);
  static const Color tileDefault = Color(0xFFF6F7F9);
  static const Color tilePressed = Color(0xFFECEEF1);
  static const Color divider = Color(0xFFE2E5EA);
  static const Color accentPrimary = Color(0xFF111111);
  static const Color accentMuted = Color(0xFF6B7280);
  static const Color textPrimary = Color(0xFF0B0C0E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color icon = Color(0xFF111111);
}

class PaletteDark {
  static const Color bgPrimary = Color(0xFF09121E);
  static const Color surfaceElev1 = Color(0xFF0F1A23);
  static const Color surfaceElev2 = Color(0xFF101E28);
  static const Color tileDefault = Color(0xFF0E1821);
  static const Color tilePressed = Color(0xFF13222C);
  static const Color divider = Color(0xFF1A2A33);
  static const Color accentPrimary = Color(0xFF5FDBD8);
  static const Color accentMuted = Color(0xFF54BEBE);
  static const Color textPrimary = Color(0xFFEAE9EA);
  static const Color textSecondary = Color(0xFF93A8B3);
  static const Color icon = Color(0xFF5FDBD8);
}

class TypographyTokens {
  static const TextStyle amountLarge = TextStyle(
    fontSize: 44,
    height: 52 / 44,
    fontWeight: FontWeight.w600,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  static const TextStyle currencyLabel = TextStyle(
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w500,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  static const TextStyle keyLabel = TextStyle(
    fontSize: 22,
    height: 26 / 22,
    fontWeight: FontWeight.w500,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  static const TextStyle meta = TextStyle(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w400,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );
}
