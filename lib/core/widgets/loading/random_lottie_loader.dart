import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RandomLottieLoader {
  static final RandomLottieLoader _instance = RandomLottieLoader._internal();

  factory RandomLottieLoader() => _instance;

  RandomLottieLoader._internal();

  final _overlayEntry = ValueNotifier<OverlayEntry?>(null);
  final List<String> lottieFiles = [
    'assets/lottie/loading1.json',
    'assets/lottie/loading2.json',
    'assets/lottie/loading3.json',
  ];

  void show(BuildContext context) {
    if (_overlayEntry.value != null) return; // Prevent multiple overlays

    final randomIndex = Random().nextInt(lottieFiles.length);
    final overlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Lottie.asset(
                        lottieFiles[randomIndex],
                        width: 150,
                        height: 150,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text("Downloading..."),
                    ),
                  ],
                ),
              ),
            ),
            // Block interaction
            Positioned.fill(
              child: GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );

    _overlayEntry.value = overlay;

    // Use addPostFrameCallback to ensure insertion happens after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(overlay);
    });
  }

  void hide() {
    _overlayEntry.value?.remove();
    _overlayEntry.value = null;
  }
}
