import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class RandomLottieLoader {
  static final RandomLottieLoader _instance = RandomLottieLoader._internal();

  factory RandomLottieLoader() => _instance;

  RandomLottieLoader._internal();

  bool _isDialogVisible = false; // Track dialog visibility

  final List<String> lottieFiles = [
    'assets/lottie/loading1.json',
    'assets/lottie/loading2.json',
    'assets/lottie/loading3.json',
  ];

  // Static method to show the loader
  static void show({double? progress}) {
    // Call the instance's show method
    _instance._show(progress: progress);
  }

  // Instance method to handle the actual showing logic
  void _show({double? progress}) {
    if (_isDialogVisible) return;

    _isDialogVisible = true;

    final randomIndex = Random().nextInt(lottieFiles.length);

    Get.dialog(
      Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Lottie.asset(
                  lottieFiles[randomIndex],
                  width: 150,
                  height: 150,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (progress != null)
                      Text(
                        progress.toStringAsPrecision(2),
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    Text(progress != null ? "Downloading..." : "Loading..."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Static method to hide the loader
  static void hide() {
    // Call the instance's hide method
    _instance._hide();
  }

  // Instance method to handle the actual hiding logic
  void _hide() {
    if (!_isDialogVisible) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      _isDialogVisible = false;
    });
  }
}
