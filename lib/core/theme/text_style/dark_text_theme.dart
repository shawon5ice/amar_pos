import 'package:flutter/material.dart';
import 'app_text_style.dart';
import '../../constants/app_colors.dart';

class DarkTextTheme {
  static TextTheme textTheme(BuildContext context) {
    return TextTheme(
      displayLarge:
      AppTextStyles.displayLarge(context).copyWith(color: AppColors.textDarkPrimary),
      displayMedium: AppTextStyles.displayMedium(context)
          .copyWith(color: AppColors.textDarkPrimary),
      displaySmall:
      AppTextStyles.displaySmall(context).copyWith(color: AppColors.textDarkPrimary),
      headlineLarge: AppTextStyles.headlineLarge(context)
          .copyWith(color: AppColors.textDarkPrimary),
      headlineMedium: AppTextStyles.headlineMedium(context)
          .copyWith(color: AppColors.textDarkPrimary),
      headlineSmall: AppTextStyles.headlineSmall(context)
          .copyWith(color: AppColors.textDarkPrimary),
      titleLarge:
      AppTextStyles.titleLarge(context).copyWith(color: AppColors.textDarkPrimary),
      titleMedium:
      AppTextStyles.titleMedium(context).copyWith(color: AppColors.textDarkPrimary),
      titleSmall:
      AppTextStyles.titleSmall(context).copyWith(color: AppColors.textDarkPrimary),
      bodyLarge:
      AppTextStyles.bodyLarge(context).copyWith(color: AppColors.textDarkPrimary),
      bodyMedium:
      AppTextStyles.bodyMedium(context).copyWith(color: AppColors.textDarkPrimary),
      bodySmall:
      AppTextStyles.bodySmall(context).copyWith(color: AppColors.textDarkSecondary),
      labelLarge:
      AppTextStyles.labelLarge(context).copyWith(color: AppColors.textDarkPrimary),
      labelMedium: AppTextStyles.labelMedium(context)
          .copyWith(color: AppColors.textDarkSecondary),
      labelSmall:
      AppTextStyles.labelSmall(context).copyWith(color: AppColors.textDarkSecondary),
    );
  }
}
