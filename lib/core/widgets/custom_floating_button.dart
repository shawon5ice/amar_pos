
import 'package:flutter/material.dart';

import '../responsive/pixel_perfect.dart';

class CustomFloatingButton extends StatelessWidget {

  const CustomFloatingButton({
    super.key,
    required this.onTap,
    this.title,
    this.bgColor,
    this.foregroundColor,
    this.icon,
    this.fontSize,
  });

  final void Function() onTap;
  final String? title;
  final Color? bgColor;
  final Color? foregroundColor;
  final IconData? icon;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipPath(
        clipper: const ShapeBorderClipper(shape: StadiumBorder()),
        child: Container(
          height: 55,
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor?? Colors.orange,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon?? Icons.add, color: foregroundColor?? Colors.white,),
              addW(8),
              Text(title?? "Add", style: TextStyle(fontSize: fontSize?? 16, color: foregroundColor?? Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}

