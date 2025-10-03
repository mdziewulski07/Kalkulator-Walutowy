import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

class AppTheme {
  const AppTheme(this.tokens);

  final AppThemeTokens tokens;

  ThemeData build() {
    final typography = buildTypography(
      tokens.colors.textPrimary,
      tokens.colors.textSecondary,
    );

    final colorScheme = ColorScheme(
      brightness: tokens.brightness,
      primary: tokens.colors.accentPrimary,
      onPrimary: tokens.colors.equalButtonText,
      secondary: tokens.colors.accentMuted,
      onSecondary: tokens.colors.textPrimary,
      error: const Color(0xFFB00020),
      onError: Colors.white,
      background: tokens.colors.backgroundPrimary,
      onBackground: tokens.colors.textPrimary,
      surface: tokens.colors.surfaceElev1,
      onSurface: tokens.colors.textPrimary,
      surfaceVariant: tokens.colors.surfaceElev2,
      onSurfaceVariant: tokens.colors.textSecondary,
      outline: tokens.colors.divider,
      shadow: Colors.black.withOpacity(0.25),
      tertiary: tokens.colors.accentMuted,
      onTertiary: tokens.colors.textPrimary,
    );

    final theme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: tokens.colors.backgroundPrimary,
      dividerColor: tokens.colors.divider,
      fontFamily: 'Inter',
      textTheme: TextTheme(
        headlineLarge: typography.amountLarge,
        titleLarge: typography.currencyLabel,
        bodyLarge: typography.meta,
        bodyMedium: typography.meta,
        bodySmall: typography.meta,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.colors.backgroundPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: tokens.colors.icon),
        titleTextStyle: typography.currencyLabel,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              tokens.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
          statusBarBrightness:
              tokens.brightness == Brightness.dark ? Brightness.dark : Brightness.light,
        ),
      ),
      cardColor: tokens.colors.surfaceElev1,
      cardTheme: CardTheme(
        color: tokens.colors.surfaceElev1,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius24),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: tokens.colors.surfaceElev2,
        selectedItemColor: tokens.colors.accentPrimary,
        unselectedItemColor: tokens.colors.accentMuted,
        selectedLabelStyle: typography.meta,
        unselectedLabelStyle: typography.meta,
        showUnselectedLabels: true,
      ),
      dividerTheme: DividerThemeData(
        color: tokens.colors.divider,
        space: AppSpacing.grid,
        thickness: 1,
      ),
      iconTheme: IconThemeData(color: tokens.colors.icon, size: 20),
    );

    return theme;
  }
}
