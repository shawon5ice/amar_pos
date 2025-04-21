import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? error;
  final double? height;

  const AuthHeader({
    super.key,
    required this.title,
    this.height,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: height?? Get.height / 2,
      child: Stack(

        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Get.height,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // stops: [.4,.75,],
                  colors: [AppColors.primary, AppColors.scaffoldBackground],
                ),
              ),
            ),
          ),
          // Image.asset(
          //   'assets/imgs/bg_login.png',
          //   height: 395.h,
          //   fit: BoxFit.cover,
          // ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/app_logo.png',
                  ),
                ),
              ),
              const Text(
                'Amar POS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w900,
                ),
              ),
              addH(32.h),
              Center(child: Text(error??'', style: context.textTheme.bodyMedium?.copyWith(color: AppColors.error,),)),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 30.pw(context),
            child: Text(
              title,
              style: const TextStyle(
                color:
                    // context.isDarkMode ? ConstantColors.kC0C0C4 :
                    Color(0xFF1D3557),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
