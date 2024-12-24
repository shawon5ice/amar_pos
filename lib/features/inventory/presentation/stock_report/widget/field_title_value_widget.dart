import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';

class FieldTitleValueWidget extends StatelessWidget {
  const FieldTitleValueWidget({
    super.key,
    required this.title,
    required this.value,
    this.titleColor,
    this.valueColor,
    this.separatorColor,
    this.tittleFontWeight,
    this.valueFontWeight,
  });

  final String title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;
  final Color? separatorColor;
  final FontWeight? tittleFontWeight;
  final FontWeight? valueFontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                  color: titleColor ?? const Color(0xff7C7C7C),
                  fontSize: 14.sp,
                  fontWeight: tittleFontWeight ?? FontWeight.w500),
            )),
        Expanded(
            child: Text(
              " : ",
              style: TextStyle(
                  color: separatorColor ?? const Color(0xff7C7C7C),
                  fontSize: 14.sp,
                  fontWeight: tittleFontWeight ?? FontWeight.w500),
            )),
        Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                  color: valueColor ?? Colors.black,
                  fontSize: 14.sp,
                  fontWeight: valueFontWeight ?? FontWeight.w500),
              textAlign: TextAlign.right,
            ))
      ],
    );
  }
}
