import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildLightTheme() {
  final TextTheme textTheme = Typography.material2021().black.apply(
        bodyColor: PaletteLight.textPrimary,
        displayColor: PaletteLight.textPrimary,
      );
  final ColorScheme colorScheme = ColorScheme.light(
    primary: PaletteLight.accentPrimary,
    onPrimary: Colors.white,
    secondary: PaletteLight.accentMuted,
    onSecondary: PaletteLight.textPrimary,
    surface: PaletteLight.surfaceElev1,
    onSurface: PaletteLight.textPrimary,
    error: Colors.redAccent,
    onError: Colors.white,
  );
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: PaletteLight.bgPrimary,
    useMaterial3: true,
    textTheme: textTheme,
    colorScheme: colorScheme,
    dividerColor: PaletteLight.divider,
    appBarTheme: const AppBarTheme(
      backgroundColor: PaletteLight.bgPrimary,
      elevation: 0,
      foregroundColor: PaletteLight.textPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: PaletteLight.surfaceElev1,
      selectedItemColor: PaletteLight.accentPrimary,
      unselectedItemColor: PaletteLight.accentMuted,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: const CardThemeData(
      color: PaletteLight.surfaceElev1,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
    ),
  );
}

ThemeData buildDarkTheme() {
  final TextTheme textTheme = Typography.material2021().white.apply(
        bodyColor: PaletteDark.textPrimary,
        displayColor: PaletteDark.textPrimary,
      );
  const ColorScheme colorScheme = ColorScheme.dark(
    primary: PaletteDark.accentPrimary,
    onPrimary: Color(0xFF0A1418),
    secondary: PaletteDark.accentMuted,
    onSecondary: PaletteDark.textPrimary,
    surface: PaletteDark.surfaceElev1,
    onSurface: PaletteDark.textPrimary,
    error: Colors.redAccent,
    onError: PaletteDark.textPrimary,
  );
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: PaletteDark.bgPrimary,
    useMaterial3: true,
    textTheme: textTheme,
    colorScheme: colorScheme,
    dividerColor: PaletteDark.divider,
    appBarTheme: const AppBarTheme(
      backgroundColor: PaletteDark.bgPrimary,
      elevation: 0,
      foregroundColor: PaletteDark.textPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: PaletteDark.surfaceElev1,
      selectedItemColor: PaletteDark.accentPrimary,
      unselectedItemColor: PaletteDark.accentMuted,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: const CardThemeData(
      color: PaletteDark.surfaceElev1,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
    ),
  );
}

TextStyle equalKeyStyle(Brightness brightness) {
  if (brightness == Brightness.dark) {
    return TypographyTokens.keyLabel.copyWith(
      color: const Color(0xFF0A1418),
      fontWeight: FontWeight.w600,
    );
  }
  return TypographyTokens.keyLabel.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
}
