import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldTitle extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const FieldTitle(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.titleSmall?.copyWith(
        color: color,
        fontSize: fontSize ?? 12.sp,
        fontWeight: fontWeight,
      ),
    );
  }
}

class RichFieldTitle extends StatelessWidget {
  const RichFieldTitle({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: text,
        style: context.textTheme.titleSmall?.copyWith(
          color: Colors.black,
          fontSize: fontSize ?? 12.sp,
          fontWeight: fontWeight,
        ),
      ),
      TextSpan(
        text: "*",
        style: context.textTheme.titleSmall?.copyWith(
          color: Colors.red,
          fontSize: fontSize ?? 12.sp,
          fontWeight: fontWeight,
        ),
      )
    ]));
  }
}
