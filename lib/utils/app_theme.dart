import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryLight = Colors.deepPurple;
  static const Color secondaryLight = Color(0xFF9575CD);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF9575CD);
  static const Color secondaryDark = Color(0xFFB39DDB);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.light(
      primary: primaryLight,
      secondary: secondaryLight,
      surface: surfaceLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: primaryLight,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryLight),
      titleTextStyle: TextStyle(
        color: primaryLight,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    iconTheme: const IconThemeData(color: primaryLight),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimaryLight),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondaryLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
      surface: surfaceDark,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: textPrimaryDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: primaryDark,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryDark),
      titleTextStyle: TextStyle(
        color: primaryDark,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    iconTheme: const IconThemeData(color: primaryDark),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimaryDark),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondaryDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.black,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.black,
    ),
  );
}
