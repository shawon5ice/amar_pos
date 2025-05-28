import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'text_style/light_text_theme.dart';
import 'text_style/text_theme_factory.dart';

class LightTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      cardColor: AppColors.card,
      textTheme: TextThemeFactory.getTextTheme(Brightness.light, context),
      appBarTheme: AppBarTheme(
        color: AppColors.scaffoldBackground,
        titleTextStyle:
        LightTextTheme.textTheme(context).titleLarge!.copyWith(
            color: Colors.black, fontSize: 24.px),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.bottomSheetBGColor
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        // Replaces `accentColor`
        surfaceTint: AppColors.scaffoldBackground,
        surface: AppColors.card,
        error: AppColors.error,
      ),
    );
  }
}
