import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';

class CustomTxtBtn extends StatelessWidget {
  final VoidCallback onTapFn;
  final String text;
  double? txtSize;
  Color? txtClr;
  FontWeight? txtWeight;
  CustomTxtBtn({
    super.key,
    required this.onTapFn,
    required this.text,
    this.txtSize,
    this.txtClr,
    this.txtWeight,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTapFn,
      child: Text(
        text,
        style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: txtSize ?? 16.px,
          // fontFamily: ConstantStrings.kFontFamily,
          color: txtClr ?? Colors.blue,
          fontWeight: txtWeight,
        ),
      ),
    );
  }
}
