import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../responsive/pixel_perfect.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback? onPressedFn;
  final String btnTxt;
  final double? txtSize;
  final FontWeight? txtWeight;
  final Size? btnSize;
  final Color? btnColor;
  final Color? txtColor;
  final Color? btnBorderColor;
  final double? btnBroderRadius;
  final String? btnIcon;
  const CustomBtn({
    super.key,
    required this.onPressedFn,
    required this.btnTxt,
    this.txtSize,
    this.txtWeight,
    this.btnSize,
    this.btnColor,
    this.txtColor,
    this.btnBorderColor,
    this.btnBroderRadius,
    this.btnIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedFn,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        fixedSize: WidgetStateProperty.all(
          btnSize ?? Size(double.infinity, 58.h),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          btnColor ?? AppColors.primary,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(btnBroderRadius ?? 6.r),
            side: BorderSide(
              color: btnBorderColor ?? btnColor ?? AppColors.primary,
              width: 1.0,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (btnIcon != null)
            SvgPicture.asset(
              btnIcon!,
              fit: BoxFit.fill,
            ),
          if (btnIcon != null) addW(5.w),
          Text(
            btnTxt,
            style: TextStyle(
              color: txtColor??Colors.white,
              fontSize: txtSize ?? 16.sp,
              fontWeight: txtWeight ?? FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
