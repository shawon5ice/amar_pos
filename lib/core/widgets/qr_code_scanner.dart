import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) async {
    if (_isScanned) return; // Prevent multiple scans
    final barcode = capture.barcodes.first;
    final code = barcode.rawValue;

    if (code != null) {
      _isScanned = true;
      await _controller.dispose().then((value)=> Navigator.of(context).pop(code));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Code')),
      body: MobileScanner(
        controller: _controller,
        onDetect: _handleDetection,
      ),
    );
  }
}