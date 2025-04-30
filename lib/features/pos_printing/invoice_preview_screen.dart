import 'dart:typed_data';
import 'package:amar_pos/core/core.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:amar_pos/features/pos_printing/pos_invoice_model.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';

import 'invoice_gen_from_screen_shot.dart';


class InvoicePreviewScreen extends StatefulWidget {
  final BluetoothDevice? device;

  InvoicePreviewScreen({this.device});

  @override
  _InvoicePreviewScreenState createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  final GlobalKey previewContainerKey = GlobalKey();
  static final tscCommand = TscCommand();
  ScreenshotController screenshotController = ScreenshotController();
  static Uint8List? generatedInvoiceImage;
  static final _printerManager = PrinterManager.instance;

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _disconnect();
  }

  void _disconnect() async {
    await BluetoothPrintPlus.disconnect();
  }

  PosInvoiceModel posInvoiceModel = PosInvoiceModel(
      storeName: "Gadgeter Pahar",
      storeAddress:
          "Shop-3/4, Basement -1, Bashundhara City Shopping Complex, Panthapath, Dhaka-1215",
      storePhone: "01879907248",
      invoiceDate: "23 Apr 2025 10:22:17 AM",
      invoiceNo: "MS-RS-12029",
      additionalCharge: 1000,
      customerAddress: "Test address",
      customerPhone: "01312000111",
      customerName: "Test Order",
      vat: 555,
      subTotal: 32550,
      discount: 200,
      products: [
        PosProduct(
            name: "Haylou Smart Watch LS02 Global version -Black",
            qty: 3,
            unitPrice: 2450,
            subTotal: 7350),
        PosProduct(
            name:
                "oraimo Watch Nova AM AMOLED Screen Curved Cover Smart Watch - SpeedBlack",
            qty: 5,
            unitPrice: 5000,
            subTotal: 25000),


      ]);

  double get subtotal =>
      posInvoiceModel.products.fold(0, (sum, item) => sum + (item.qty * item.unitPrice));

  double get vat => subtotal * 0.05;

  double get total => subtotal + vat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoice Preview')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(child: _buildInvoiceWidget(context)),
            ),
            ElevatedButton(
              onPressed: () async {
                Uint8List? image8List = await InvoiceGenerator.generateInvoice(
                  context: context,
                  widget: _buildInvoiceWidget(context),
                );

                if (image8List != null) {
                  final decoded = img.decodeImage(image8List);
                  if (decoded == null) {
                    print("Could not decode image");
                    return;
                  }

                  final resized = img.copyResize(decoded, width: 576); // Full 80mm width

                  final generator = Generator(PaperSize.mm80, await CapabilityProfile.load());
                  final bytes = <int>[
                    ...generator.imageRaster(resized, align: PosAlign.center),
                    // ...generator.qrcode(posInvoiceModel.invoiceNo,size: QRSize.size6),
                    ...generator.cut(),
                  ];

                  // ✅ Convert to Uint8List
                  BluetoothPrintPlus.write(Uint8List.fromList(bytes));
                }
              },

              child: Text('Print Invoice'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInvoiceWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10
      ),
      width: 576,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(posInvoiceModel.storeName, style: TextStyle(fontFamily: 'RobotoMono',fontWeight: FontWeight.bold, fontSize: 26,letterSpacing: 1),),
                Text(posInvoiceModel.storeAddress, style: TextStyle(fontFamily: 'RobotoMono', fontSize: 16,fontWeight: FontWeight.w600,letterSpacing: 1),textAlign: TextAlign.center,),
                Text(posInvoiceModel.storePhone, style: TextStyle(fontFamily: 'RobotoMono', fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 1),textAlign: TextAlign.center,),
                Text("Invoice # :${posInvoiceModel.invoiceNo}", style: TextStyle(fontFamily: 'RobotoMono', fontSize: 22,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                Text("Date & Time :${posInvoiceModel.invoiceDate}", style: TextStyle(fontFamily: 'RobotoMono', fontSize: 14,fontWeight: FontWeight.w600,letterSpacing: 1),textAlign: TextAlign.center,),
                // SizedBox(height: 4,),
              ],
            ),
          ),
         //  Divider(thickness: 2,height: 4,color: Colors.black,),
         //  Text(posInvoiceModel.customerName, style: TextStyle(fontFamily: 'CourierPrime', fontSize: 22,fontWeight: FontWeight.bold,letterSpacing: 2),textAlign: TextAlign.center,),
         //  Text(posInvoiceModel.customerPhone, style: TextStyle( fontSize: 22,fontWeight: FontWeight.w600,letterSpacing: 2),textAlign: TextAlign.center,),
         //  Text("Address : ${posInvoiceModel.customerAddress ?? 'N/A'}", style: TextStyle( fontSize: 20,fontWeight: FontWeight.w500,letterSpacing: 2),textAlign: TextAlign.center,),
         //  const Divider(color: Colors.black,thickness: 2,),
         //  const Row(
         //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
         //    children: [
         //      Expanded(flex: 3, child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,letterSpacing: 2),)),
         //      Expanded(flex: 1, child: Text('Qty',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,letterSpacing: 2),)),
         //      Expanded(flex: 1, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,letterSpacing: 2),)),
         //      Expanded(flex: 1, child: Text('Total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,letterSpacing: 2),)),
         //    ],
         //  ),
         // const  Divider(
         //    thickness: 2, height: 1,
         //    color: Colors.black,
         //  ),
         //  ...posInvoiceModel.products.map((item) {
         //    int index = posInvoiceModel.products.indexOf(item);
         //
         //    return Padding(
         //        padding: const EdgeInsets.symmetric(vertical: 4.0),
         //        child: Row(
         //          mainAxisAlignment: MainAxisAlignment.spaceBetween,
         //          children: [
         //            Expanded(flex: 3, child: Text("${index+1}. ${item.name}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,letterSpacing: 2),)),
         //            Expanded(flex: 1, child: Text('x${Methods.getFormattedNumber(item.qty.toDouble())}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,letterSpacing: 2),)),
         //            Expanded(flex: 1, child: Text('${Methods.getFormatedPrice((item.unitPrice).toDouble())}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,letterSpacing: 2),)),
         //            Expanded(flex: 1, child: Text('${Methods.getFormatedPrice((item.qty * item.unitPrice).toDouble())}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,letterSpacing: 2),)),
         //          ],
         //        ),
         //      );
         //  }),
         //  const Divider(color: Colors.black,thickness: 2,),
         //  _buildSummaryRow('Subtotal', subtotal),
         //  _buildSummaryRow('VAT', posInvoiceModel.vat.toDouble()),
         //  _buildSummaryRow('Additional Charge', posInvoiceModel.additionalCharge.toDouble()),
         //  _buildSummaryRow('Discount', posInvoiceModel.discount.toDouble()),
         //  _buildSummaryRow('Total', total, isBold: true),
        ],
      ),
    );
  }


  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isBold ? TextStyle(fontWeight: FontWeight.w600,fontSize: 18) : TextStyle(fontSize: 16,letterSpacing: 2) ),
          Text('${Methods.getFormatedPrice(amount)}',
              style:  isBold ? TextStyle(fontWeight: FontWeight.w600,fontSize: 18) : TextStyle(fontSize: 16,letterSpacing: 2) ),
        ],
      ),
    );
  }
}
