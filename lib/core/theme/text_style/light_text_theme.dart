import 'package:flutter/material.dart';
import 'app_text_style.dart';
import '../../constants/app_colors.dart';

class LightTextTheme {
  static TextTheme textTheme(BuildContext context) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge(context).copyWith(color: AppColors.textPrimary),
      displayMedium: AppTextStyles.displayMedium(context).copyWith(color: AppColors.textPrimary),
      displaySmall: AppTextStyles.displaySmall(context).copyWith(color: AppColors.textPrimary),
      headlineLarge: AppTextStyles.headlineLarge(context).copyWith(color: AppColors.textPrimary),
      headlineMedium: AppTextStyles.headlineMedium(context).copyWith(color: AppColors.textPrimary),
      headlineSmall: AppTextStyles.headlineSmall(context).copyWith(color: AppColors.textPrimary),
      titleLarge: AppTextStyles.titleLarge(context).copyWith(color: AppColors.textPrimary),
      titleMedium: AppTextStyles.titleMedium(context).copyWith(color: AppColors.textPrimary),
      titleSmall: AppTextStyles.titleSmall(context).copyWith(color: AppColors.textPrimary),
      bodyLarge: AppTextStyles.bodyLarge(context).copyWith(color: AppColors.textPrimary),
      bodyMedium: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.textPrimary),
      bodySmall: AppTextStyles.bodySmall(context).copyWith(color: AppColors.textSecondary),
      labelLarge: AppTextStyles.labelLarge(context).copyWith(color: AppColors.textPrimary),
      labelMedium: AppTextStyles.labelMedium(context).copyWith(color: AppColors.textSecondary),
      labelSmall: AppTextStyles.labelSmall(context).copyWith(color: AppColors.textSecondary),
    );
  }
}
