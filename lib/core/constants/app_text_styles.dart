import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Dark Theme Styles
  static const TextStyle darkHeadline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDarkPrimary,
  );

  static const TextStyle darkBodyText1 = TextStyle(
    fontSize: 16,
    color: AppColors.textDarkPrimary,
  );

  static const TextStyle darkBodyText2 = TextStyle(
    fontSize: 14,
    color: AppColors.textDarkSecondary,
  );
}
