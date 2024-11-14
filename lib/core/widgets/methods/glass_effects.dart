import "package:flutter/material.dart";

BoxShadow glassEffect2() {
  return BoxShadow(
      color: const Color(0xff3496F5).withOpacity(.06),
      spreadRadius: 0,
      blurRadius: 24,
      offset: const Offset(-10,-6)
  );
}

BoxShadow glassEffect1() {
  return BoxShadow(
      color: const Color(0xffFBC60F).withOpacity(.1),
      spreadRadius: 0,
      blurRadius: 14,
      offset: const Offset(0,4)
  );
}

BoxDecoration glassMorphismBoxDecoration({double? borderRadius, Color? color,Color? borderColor}) {

  return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius??6),
      color: color??Colors.white.withOpacity(.7),
      border: Border.all(color: borderColor??Colors.white, width: borderColor != null?1:2),
      boxShadow: [
        glassEffect1(),
        glassEffect2(),
      ]);
}