import 'package:flutter/material.dart';
import 'package:kalkulator_walutowy/core/ui/tokens.dart';

ThemeData buildLightTheme(CurrencyThemeData data) {
  final colors = data.lightColors;
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: colors.background,
    colorScheme: ColorScheme.light(
      surface: colors.surface1,
      background: colors.background,
      primary: colors.accent,
      secondary: colors.accentMuted,
      onSurface: colors.textPrimary,
      onPrimary: Colors.white,
    ),
    textTheme: data.typography.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    ),
    dividerColor: colors.divider,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.surface1,
      indicatorColor: colors.accent.withOpacity(0.12),
      labelTextStyle: MaterialStateProperty.all(TextStyle(color: colors.textPrimary)),
    ),
  );
}

ThemeData buildDarkTheme(CurrencyThemeData data) {
  final colors = data.darkColors;
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: colors.background,
    colorScheme: ColorScheme.dark(
      surface: colors.surface1,
      background: colors.background,
      primary: colors.accent,
      secondary: colors.accentMuted,
      onSurface: colors.textPrimary,
      onPrimary: const Color(0xFF0A1418),
    ),
    textTheme: data.typography.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    ),
    dividerColor: colors.divider,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.surface1,
      indicatorColor: colors.accent.withOpacity(0.24),
      labelTextStyle: MaterialStateProperty.all(TextStyle(color: colors.textPrimary)),
    ),
  );
}
