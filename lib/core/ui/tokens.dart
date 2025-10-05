import 'package:flutter/material.dart';

class AppColorScheme {
  const AppColorScheme({
    required this.bgPrimary,
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
  });

  final Color bgPrimary;
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
}

class AppTokens {
  static const double gutter = 20;
  static const Radius radius8 = Radius.circular(8);
  static const Radius radius12 = Radius.circular(12);
  static const Radius radius16 = Radius.circular(16);
  static const Radius radius20 = Radius.circular(20);
  static const Radius radius24 = Radius.circular(24);
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(999));

  static const light = AppColorScheme(
    bgPrimary: Color(0xFFF7F8FA),
    surfaceElev1: Color(0xFFFFFFFF),
    surfaceElev2: Color(0xFFF3F4F6),
    tileDefault: Color(0xFFF6F7F9),
    tilePressed: Color(0xFFECEEF1),
    divider: Color(0xFFE2E5EA),
    accentPrimary: Color(0xFF111111),
    accentMuted: Color(0xFF6B7280),
    textPrimary: Color(0xFF0B0C0E),
    textSecondary: Color(0xFF6B7280),
    icon: Color(0xFF111111),
  );

  static const dark = AppColorScheme(
    bgPrimary: Color(0xFF09121E),
    surfaceElev1: Color(0xFF0F1A23),
    surfaceElev2: Color(0xFF101E28),
    tileDefault: Color(0xFF0E1821),
    tilePressed: Color(0xFF13222C),
    divider: Color(0xFF1A2A33),
    accentPrimary: Color(0xFF5FDBD8),
    accentMuted: Color(0xFF54BEBE),
    textPrimary: Color(0xFFEAE9EA),
    textSecondary: Color(0xFF93A8B3),
    icon: Color(0xFF5FDBD8),
  );
}

class AppTypography {
  static TextTheme textTheme(AppColorScheme scheme) {
    return TextTheme(
      displayLarge: const TextStyle(fontFamily: 'SF Pro', fontSize: 44, fontWeight: FontWeight.w500, height: 52 / 44),
    ).apply(
      bodyColor: scheme.textPrimary,
      displayColor: scheme.textPrimary,
    );
  }

  static const TextStyle amountLarge = TextStyle(
    fontFamily: 'SF Pro',
    fontFeatures: [
      FontFeature.tabularFigures(),
      FontFeature.enable('case'),
    ],
    fontSize: 44,
    fontWeight: FontWeight.w500,
    height: 52 / 44,
  );

  static const TextStyle currencyLabel = TextStyle(
    fontFamily: 'SF Pro',
    fontFeatures: [
      FontFeature.tabularFigures(),
      FontFeature.enable('case'),
    ],
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 28 / 24,
  );

  static const TextStyle keyLabel = TextStyle(
    fontFamily: 'SF Pro',
    fontFeatures: [
      FontFeature.tabularFigures(),
      FontFeature.enable('case'),
    ],
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 26 / 22,
  );

  static const TextStyle meta = TextStyle(
    fontFamily: 'SF Pro',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 16 / 13,
    fontFeatures: [
      FontFeature.tabularFigures(),
      FontFeature.enable('case'),
    ],
  );
}
