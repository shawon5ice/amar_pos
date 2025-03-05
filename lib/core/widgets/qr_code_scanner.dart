import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For compute
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: AiBarcodeScanner(
        hideSheetTitle: true,
        hideSheetDragHandler: true,
        onDispose: () {
          debugPrint("Barcode scanner disposed!");
        },
        hideGalleryButton: false,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (BarcodeCapture capture) {
          // This function is called when a barcode is detected
          final String? scannedValue = capture.barcodes.first.rawValue;
          debugPrint("Barcode scanned: $scannedValue");

          // If a valid value is found, process it in the background and pop the result back
          if (scannedValue != null) {
            _processScannedValueInBackground(scannedValue);
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

  // Background processing of the scanned value
  Future<void> _processScannedValueInBackground(String scannedValue) async {
    try {
      setState(() {
        _isScanning = true;
      });

      // Perform any heavy processing or network request in the background isolate
      final processedValue = await compute(_processBarcode, scannedValue);

      // Once processed, pop the processed value back to the calling screen
      if (processedValue != null) {
        Navigator.of(context).pop(processedValue); // Return the processed value
      }
    } catch (e) {
      debugPrint('Error processing scanned value: $e');
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  // This is the background function that will run in a separate isolate
  static Future<String?> _processBarcode(String barcode) async {
    return barcode; // Just an example of processed data
  }
}
