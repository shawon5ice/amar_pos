import 'package:flutter/material.dart';

extension PixelPerfect on num {
  double ph(BuildContext context) => this * (MediaQuery.of(context).size.height / 926);
  double pw(BuildContext context) => this * (MediaQuery.of(context).size.width / 428);
  double get px => toDouble(); // No scaling if an absolute size is needed
}

SizedBox addH(num height) => SizedBox(height: height.toDouble(),);
SizedBox addW(num width) => SizedBox(width: width.toDouble(),);