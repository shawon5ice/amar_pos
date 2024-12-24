import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgIconButton extends StatelessWidget {
  const CustomSvgIconButton({
    super.key,
    required this.bgColor,
    required this.onTap,
    required this.assetPath,
  });

  final Color bgColor;
  final String assetPath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
          radius: 24,
          backgroundColor: bgColor,
          child: SvgPicture.asset(assetPath)),
    );
  }
}
