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

  // void _handleDetection(BarcodeCapture capture) async {
  //   if (_isScanned) return; // Prevent multiple scans
  //   final barcode = capture.barcodes.first;
  //   final code = barcode.rawValue;
  //
  //   if (code != null) {
  //     _isScanned = true;
  //     await _controller
  //         .dispose()
  //         .then((value) => Navigator.of(context).pop(code));
  //   }
  // }

  bool _isDialogOpen = false;
  bool _hasHandled = false;

  void _handleBarcodes(List<Barcode> barcodes) async {
    if (_hasHandled || _isDialogOpen) return;

    final validBarcodes = barcodes.where((b) => b.rawValue != null).toList();

    if (validBarcodes.isEmpty) return;

    _hasHandled = true;

    if (validBarcodes.length == 1) {
      await _controller.dispose().then(
              (value) => Navigator.of(context).pop(validBarcodes.first.rawValue!));
    } else {
      _isDialogOpen = true;

      final selected = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select a Barcode'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: validBarcodes
                  .map((b) => Card(
                        child: ListTile(
                          title: Text(b.rawValue!),
                          onTap: () => Navigator.of(context).pop(b.rawValue),
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      );

      _isDialogOpen = false;

      if (selected != null) {
        await _controller.dispose().then(
                (value) => Navigator.of(context).pop(selected));
      } else {
        // Reset flag if user dismissed dialog without selection
        _hasHandled = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Code')),
      body: MobileScanner(
        controller: _controller,
        onDetect: (scan) => _handleBarcodes(scan.barcodes),
      ),
    );
  }
}
