import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:screenshot/screenshot.dart';

class InvoiceGenerator {
  static Uint8List? generatedInvoiceImage;
  static final ScreenshotController _screenshotController = ScreenshotController();

  static Future<Uint8List?> createInvoiceAndPrint({
    required Widget widget,
    required BuildContext context,
  }) async {
    return await generateInvoice(context: context, widget: widget);

    // if (PrinterService.isPrinterConnected) {
    //   log('[invoice_generator] Printing invoice');
    //   await PrinterService.printInvoiceFromImage(imageData: generatedInvoiceImage);
    // }
  }

  static Future<Uint8List?> generateInvoice({
    required BuildContext context,
    required Widget widget,
  }) async {
    log('[invoice_generator] Generating invoice');
    generatedInvoiceImage = null;

    if (context.mounted) {
      await _screenshotController.captureFromLongWidget(
          InheritedTheme.captureAll(
            context,
            Material(
              child: widget
            ),
          ),
        delay: const Duration(milliseconds: 100),
        context: context,
        pixelRatio: 4
      )
          .then((capturedImage) async {
        generatedInvoiceImage = capturedImage;
      })
          .whenComplete(() {
        if (generatedInvoiceImage != null) {
          log('[invoice_generator] invoice generated');
          return generatedInvoiceImage;
        }
      })
          .catchError((onError) {
        log('[invoice_generator] Failed to generate invoice: $onError');
        //
        // Fluttertoast.showToast(
        //     msg: "Failed to generate invoice",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     // backgroundColor: Colors.red,
        //     // textColor: Colors.white,
        //     fontSize: 16.0
        // );

      });
    }
    return generatedInvoiceImage;
  }
}