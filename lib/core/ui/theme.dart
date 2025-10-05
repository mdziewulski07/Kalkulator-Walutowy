import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

class AppTheme {
  static ThemeData light() {
    const scheme = AppTokens.light;
    return _baseTheme(scheme).copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: scheme.bgPrimary,
      colorScheme: const ColorScheme.light().copyWith(
        primary: scheme.accentPrimary,
        surface: scheme.surfaceElev1,
        secondary: scheme.accentMuted,
        onPrimary: Colors.white,
        onSurface: scheme.textPrimary,
      ),
    );
  }

  static ThemeData dark() {
    const scheme = AppTokens.dark;
    return _baseTheme(scheme).copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scheme.bgPrimary,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: scheme.accentPrimary,
        surface: scheme.surfaceElev1,
        secondary: scheme.accentMuted,
        onPrimary: const Color(0xFF0A1418),
        onSurface: scheme.textPrimary,
      ),
    );
  }

  static ThemeData _baseTheme(AppColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'SF Pro',
      textTheme: AppTypography.textTheme(scheme),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.bgPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.currencyLabel.copyWith(
          color: scheme.textPrimary,
        ),
        iconTheme: IconThemeData(color: scheme.icon),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness:
              scheme == AppTokens.light ? Brightness.light : Brightness.dark,
          statusBarIconBrightness:
              scheme == AppTokens.light ? Brightness.dark : Brightness.light,
        ),
      ),
      dividerColor: scheme.divider,
    );

    return base.copyWith(
      cardTheme: CardTheme(
        color: scheme.surfaceElev1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: scheme.accentPrimary,
        unselectedItemColor: scheme.accentMuted,
        backgroundColor: scheme.surfaceElev1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceElev2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.accentPrimary, width: 1.5),
        ),
      ),
    );
  }
}
