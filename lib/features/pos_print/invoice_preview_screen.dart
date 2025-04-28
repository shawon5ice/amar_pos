import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class InvoicePreviewScreen extends StatefulWidget {
  const InvoicePreviewScreen({super.key,required this.device});
  final BluetoothDevice device;

  @override
  State<InvoicePreviewScreen> createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
