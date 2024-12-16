import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';


class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AiBarcodeScanner(
        hideSheetTitle: true,
        hideSheetDragHandler: true,
        onDispose: () {
          /// Called when the scanner is disposed
          debugPrint("Barcode scanner disposed!");
        },
        hideGalleryButton: false,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (BarcodeCapture capture) {
          /// The scanned barcode value
          final String? scannedValue = capture.barcodes.first.rawValue;
          debugPrint("Barcode scanned: $scannedValue");

          /// Pop the result back to the calling widget
          if (scannedValue != null) {
            Navigator.of(context).pop(scannedValue);
          }
        },
        validator: (value) {
          if (value.barcodes.isEmpty) {
            return false;
          }
          return true;
        },
      ),
    );
  }
}