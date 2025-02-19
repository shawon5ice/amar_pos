import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../widgets/loading/random_lottie_loader.dart';
import '../../widgets/methods/helper_methods.dart';

class ErrorExtractor {
  /// Extracts all error messages from a given JSON response.
  static extractErrorMessages(Map<String, dynamic> response) {
    if (response['errors'] is Map<String, dynamic>) {
      final errors = response['errors'] as Map<String, dynamic>;
      return errors.values
          .expand((messages) => messages) // Flatten the lists
          .whereType<String>() // Ensure the values are strings
          .toList();
    }else{
      return [response["message"]];
    }
  }

  static List<Widget> getListOfTextWidget(List<String> errors) {
    int index = 0;
    return errors
        .map(
          (e) => Text(
            "${errors.length > 1 ? '${++index}.' : ''} $e",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        )
        .toList();
  }

  static bool isDialogOpen(BuildContext context) {
    return Navigator.of(context).canPop();
  }
  /// Shows a dialog with the extracted error messages.
  static Future<void> showErrorDialog(
      BuildContext context, Map<String, dynamic> response, ) async {
    logger.i(response);
    final errorMessages = extractErrorMessages(response);

    var widgets = getListOfTextWidget(errorMessages);

    if (isDialogOpen(context)) {
      Get.back();
      print('A dialog is currently open!');
    } else {
      print('No dialog is open.');
    }


    if (errorMessages.isNotEmpty) {
      await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Dismiss",
        barrierColor: Colors.black54, // Background dimming
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                color: const Color(0xfff44236),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppAssets.attentionIcon, width: 50, height: 50),
                      const SizedBox(height: 16),
                      const Text(
                        "Error!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: widgets,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          RandomLottieLoader.hide();
                          Methods.hideLoading();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 28,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Text(
                              "CLOSE",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0); // Start from above the screen
          const end = Offset(0.0, 0.0); // End at the top-center position
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );

    }
  }

  static Future<void> showSingleErrorDialog(
      BuildContext context, String message, ) async {

    if (message.isNotEmpty) {
      await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Dismiss",
        barrierColor: Colors.black54, // Background dimming
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                color: const Color(0xfff44236),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppAssets.attentionIcon, width: 50, height: 50),
                      const SizedBox(height: 16),
                      const Text(
                        "Error!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          RandomLottieLoader.hide();
                          Methods.hideLoading();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 28,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Text(
                              "CLOSE",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0); // Start from above the screen
          const end = Offset(0.0, 0.0); // End at the top-center position
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );

    }
  }
}
