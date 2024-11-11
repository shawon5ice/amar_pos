import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.marginHorizontal = 0,
    this.marginVertical = 0,
    this.height = 60,
    this.radius = 40,
    this.width = double.infinity,
    this.text = "Add Now",
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.onTap,
  });

  final double marginHorizontal;
  final double marginVertical;
  final double radius;
  final double height;
  final double width;
  final String text;
  final Color color;
  final Color textColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: marginVertical),
        height: height.px,
        width: width.px,
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(40))),
        child: Center(
          child: Text(
            text,
            style: context.textTheme.titleMedium
                ?.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
