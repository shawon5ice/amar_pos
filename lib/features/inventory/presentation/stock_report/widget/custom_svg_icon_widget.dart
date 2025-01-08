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




class CustomSvgSmallIconButton extends StatelessWidget {
  const CustomSvgSmallIconButton({
    super.key,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
    required this.assetPath,
  });

  final Color bgColor;
  final Color borderColor;
  final String assetPath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        // padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: .5)
        ),
        child: Center(child: SvgPicture.asset(assetPath,width: 12,height: 12,),),
      ),
    );
  }
}
