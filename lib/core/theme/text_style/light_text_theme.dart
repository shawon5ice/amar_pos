import 'package:flutter/material.dart';
import 'app_text_style.dart';
import '../../constants/app_colors.dart';

class LightTextTheme {
  static TextTheme textTheme(BuildContext context) {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      displayMedium: AppTextStyles.displayMedium(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      displaySmall: AppTextStyles.displaySmall(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      headlineLarge: AppTextStyles.headlineLarge(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      headlineMedium: AppTextStyles.headlineMedium(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      headlineSmall: AppTextStyles.headlineSmall(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      titleLarge: AppTextStyles.titleLarge(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      titleMedium: AppTextStyles.titleMedium(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      titleSmall: AppTextStyles.titleSmall(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      bodyLarge: AppTextStyles.bodyLarge(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      bodyMedium: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      bodySmall: AppTextStyles.bodySmall(context).copyWith(color: AppColors.textSecondary,fontFamily: "SFPro",),
      labelLarge: AppTextStyles.labelLarge(context).copyWith(color: AppColors.textPrimary,fontFamily: "SFPro",),
      labelMedium: AppTextStyles.labelMedium(context).copyWith(color: AppColors.textSecondary,fontFamily: "SFPro",),
      labelSmall: AppTextStyles.labelSmall(context).copyWith(color: AppColors.textSecondary,fontFamily: "SFPro",),
    );
  }
}
