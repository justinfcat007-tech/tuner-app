import 'package:flutter/material.dart';

/// App theme configuration using Material 3
class AppTheme {
  // Design tokens from Vue project
  static const Color canvas = Color(0xFF10151D);
  static const Color surface = Color(0xFF18212C);
  static const Color surfaceRaised = Color(0xFF202C39);
  static const Color surfaceWarm = Color(0xFFF7F0E3);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFB8C2CC);
  static const Color textMuted = Color(0xFF7F8A96);
  static const Color ink = Color(0xFF1A222C);
  static const Color accent = Color(0xFFE7B65C);
  static const Color accentStrong = Color(0xFFC98B32);
  static const Color accentSoft = Color(0xFFF8E1B3);
  static const Color success = Color(0xFF63C79A);
  static const Color warning = Color(0xFFEEB45B);
  static const Color danger = Color(0xFFE97979);
  static const Color border = Color(0xFF314050);
  static const Color borderStrong = Color(0xFF4A5D70);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: canvas,
    colorScheme: ColorScheme.dark(
      primary: accent,
      secondary: accentSoft,
      surface: surface,
      error: danger,
      onPrimary: ink,
      onSecondary: ink,
      onSurface: textPrimary,
      onError: textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: canvas,
      foregroundColor: textPrimary,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: ink,
        minimumSize: const Size(44, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        minimumSize: const Size(44, 44),
      ),
    ),
  );
}
