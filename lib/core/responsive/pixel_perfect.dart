import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

double get scaleWidth => Get.width / 428;
double get scaleHeight => Get.height / 926;

extension PixelPerfect on num {
  double ph(BuildContext context) => this * (MediaQuery.of(context).size.height / 926);
  double pw(BuildContext context) => this * (MediaQuery.of(context).size.width / 428);
  double get px => toDouble(); // No scaling if an absolute size is needed
}

SizedBox addH(num height) => SizedBox(height: height.toDouble(),);
SizedBox addW(num width) => SizedBox(width: width.toDouble(),);

extension NumExtension on num{
  double get h => this * scaleHeight;

  double get w => this * scaleWidth;

  double get sp => this * Get.context!.textScaleFactor;

  double get r => this * min(scaleWidth, scaleHeight);
}