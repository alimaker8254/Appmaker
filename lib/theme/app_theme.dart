import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0A0E27);
  static const navy = Color(0xFF1A1F3A);
  static const neonBlue = Color(0xFF00BFFF);
  static const neonCyan = Color(0xFF00E5FF);
  static const neonGreen = Color(0xFF00FF7F);
  static const neonGold = Color(0xFFFFD700);
  static const neonOrange = Color(0xFFFF8C00);
  static const neonPurple = Color(0xFFBF00FF);
  static const white = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFB0C4DE);
}

class AppTheme {
  static ThemeData build(ThemeData base) => base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.neonCyan, selectionColor: AppColors.neonBlue),
  );
}
