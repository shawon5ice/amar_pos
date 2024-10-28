import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'text_style/dark_text_theme.dart';

class DarkTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
      cardColor: AppColors.darkCard,
      textTheme: DarkTextTheme.textTheme(context),
      appBarTheme: AppBarTheme(
        color: AppColors.darkPrimary,
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkAccent,
        // Replaces `accentColor`
        background: AppColors.darkScaffoldBackground,
        surface: AppColors.darkCard,
        error: AppColors.error,
      ),
    );
  }
}
