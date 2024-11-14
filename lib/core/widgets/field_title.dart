import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldTitle extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  const FieldTitle(this.text,{
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
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
