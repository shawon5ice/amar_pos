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

  void show(BuildContext context, double? progress) {
    // Prevent multiple overlays
    if (_overlayEntry.value != null) return;

    final randomIndex = Random().nextInt(lottieFiles.length);

    // Create the overlay
    showDialog(
        barrierDismissible: false,
        context: context, builder: (context) =>
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(progress != null)Text(progress.toStringAsPrecision(2),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),),
                      Text("Downloading..."),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
    // final overlay = OverlayEntry(
    //   builder: (context) => Material(
    //     color: Colors.black.withOpacity(0.5),
    //     child: Stack(
    //       children: [
    //         Center(
    //           child: Container(
    //             width: 300,
    //             height: 300,
    //             decoration: const BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.all(Radius.circular(16)),
    //             ),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 SizedBox(height: 50),
    //                 Center(
    //                   child: Lottie.asset(
    //                     lottieFiles[randomIndex],
    //                     width: 150,
    //                     height: 150,
    //                   ),
    //                 ),
    //                 const Align(
    //                   alignment: Alignment.bottomCenter,
    //                   child: Text("Downloading..."),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         // Block interaction
    //         Positioned.fill(
    //           child: GestureDetector(
    //             onTap: () {},
    //             behavior: HitTestBehavior.opaque,
    //             child: Container(),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    // _overlayEntry.value = overlay;

    // Insert the overlay immediately
    // Overlay.of(context).insert(overlay);
  }


  void hide(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      // _overlayEntry.value?.remove();
      // _overlayEntry.value = null;
    });
  }

}
