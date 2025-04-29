import 'dart:convert';
import 'dart:typed_data';
import 'package:amar_pos/features/pos_printing/pos_invoice_model.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future<Uint8List> generateOptimizedInvoicePdf(PosInvoiceModel posInvoiceModel) async {
  final pdf = pw.Document();

  final subtotal = posInvoiceModel.products.fold<num>(
    0,
        (sum, item) => sum + (item.qty * item.unitPrice),
  );

  final vat = posInvoiceModel.vat.toDouble();
  final additionalCharge = posInvoiceModel.additionalCharge.toDouble();
  final discount = posInvoiceModel.discount.toDouble();
  final total = subtotal + vat + additionalCharge - discount;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (pw.Context context) {
        return pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 4),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(posInvoiceModel.storeName, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.Text(posInvoiceModel.storeAddress, style: pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
                    pw.Text(posInvoiceModel.storePhone, style: pw.TextStyle(fontSize: 8)),
                    pw.SizedBox(height: 4),
                    pw.Text("Invoice #: ${posInvoiceModel.invoiceNo}", style: pw.TextStyle(fontSize: 8)),
                    pw.Text("Date: ${posInvoiceModel.invoiceDate}", style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              pw.Divider(thickness: 1),
              pw.Text('Customer: ${posInvoiceModel.customerName}', style: pw.TextStyle(fontSize: 8)),
              pw.Text('Phone: ${posInvoiceModel.customerPhone}', style: pw.TextStyle(fontSize: 8)),
              if (posInvoiceModel.customerAddress != null) pw.Text('Address: ${posInvoiceModel.customerAddress}', style: pw.TextStyle(fontSize: 8)),
              pw.Divider(thickness: 1),
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text("Item", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Qty', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Price', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text('Total', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              pw.Divider(thickness: 1),
              ...posInvoiceModel.products.map((item) {
                int index = posInvoiceModel.products.indexOf(item);
                return pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text("${index+1}. ${item.name}", style: pw.TextStyle(fontSize: 8)),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('x${item.qty}', style: const pw.TextStyle(fontSize: 8)),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('${item.unitPrice}', style: pw.TextStyle(fontSize: 8)),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('${item.qty * item.unitPrice}', style: pw.TextStyle(fontSize: 8)),
                    ),
                  ],
                ),
              );
              }),
              pw.Divider(thickness: 1),
              _buildSummaryRow('Subtotal', subtotal),
              _buildSummaryRow('VAT', vat),
              _buildSummaryRow('Add. Charge', additionalCharge),
              _buildSummaryRow('Discount', discount),
              pw.Divider(thickness: 1),
              _buildSummaryRow('Total', total, isBold: true),
              pw.Divider(thickness: 1),
              pw.Center(child: pw.Text('Thank You!', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))),
            ],
          ),
        );
      },
    ),
  );

  return await pdf.save();
}

pw.Widget _buildSummaryRow(String label, num value, {bool isBold = false}) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 8, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text('${value.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 8, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    ),
  );
}


// void printInvoice(BluetoothDevice device, PosInvoiceModel posInvoiceModel) async {
//   try {
//     // 1. Generate Ticket Bytes
//     final profile = await CapabilityProfile.load(); // use default unless you have a custom profile
//     final generator = Generator(PaperSize.mm80, profile);
//
//     final List<int> bytes = [];
//
//     // HEADER
//     bytes.addAll(generator.text(
//       posInvoiceModel.storeName,
//       styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
//     ));
//     bytes.addAll(generator.text(
//       posInvoiceModel.storeAddress,
//       styles: PosStyles(align: PosAlign.center),
//     ));
//     bytes.addAll(generator.text(
//       posInvoiceModel.storePhone,
//       styles: PosStyles(align: PosAlign.center),
//     ));
//     bytes.addAll(generator.text(
//       "Invoice #: ${posInvoiceModel.invoiceNo}",
//       styles: PosStyles(align: PosAlign.center, bold: true),
//     ));
//     bytes.addAll(generator.text(
//       "Date & Time: ${posInvoiceModel.invoiceDate}",
//       styles: PosStyles(align: PosAlign.center),
//     ));
//     bytes.addAll(generator.hr());
//
//     // CUSTOMER
//     bytes.addAll(generator.text(
//       posInvoiceModel.customerName,
//       styles: PosStyles(align: PosAlign.left),
//     ));
//     bytes.addAll(generator.text(
//       posInvoiceModel.customerPhone,
//       styles: PosStyles(align: PosAlign.left),
//     ));
//     bytes.addAll(generator.text(
//       "Address: ${posInvoiceModel.customerAddress ?? 'N/A'}",
//       styles: PosStyles(align: PosAlign.left),
//     ));
//     bytes.addAll(generator.hr());
//
//     // PRODUCTS
//     for (var item in posInvoiceModel.products) {
//       bytes.addAll(generator.row([
//         PosColumn(
//           text: '${item.name.substring(0, item.name.length > 10 ? 10 : item.name.length)}',
//           width: 6,
//         ),
//         PosColumn(
//           text: 'x${item.qty}',
//           width: 2,
//         ),
//         PosColumn(
//           text: '${item.unitPrice}',
//           width: 2,
//         ),
//         PosColumn(
//           text: '${item.qty * item.unitPrice}',
//           width: 2,
//         ),
//       ]));
//     }
//
//     bytes.addAll(generator.hr());
//
//     // TOTALS
//     bytes.addAll(generator.text('Subtotal: ${posInvoiceModel.subTotal}', styles: PosStyles(align: PosAlign.right)));
//     bytes.addAll(generator.text('VAT: ${posInvoiceModel.vat}', styles: PosStyles(align: PosAlign.right)));
//     bytes.addAll(generator.text('Additional: ${posInvoiceModel.additionalCharge}', styles: PosStyles(align: PosAlign.right)));
//     bytes.addAll(generator.text('Discount: ${posInvoiceModel.discount}', styles: PosStyles(align: PosAlign.right)));
//     bytes.addAll(generator.text('Total: ${posInvoiceModel.subTotal}', styles: PosStyles(align: PosAlign.right, bold: true)));
//     bytes.addAll(generator.feed(2));
//     bytes.addAll(generator.cut());
//
//     // 2. Discover services and find printer characteristic
//     List<BluetoothService> services = await device.discoverServices();
//
//     BluetoothCharacteristic? targetCharacteristic;
//
//     for (var service in services) {
//       for (var characteristic in service.characteristics) {
//         if ((characteristic.properties.write || characteristic.properties.writeWithoutResponse) &&
//             !characteristic.uuid.toString().toLowerCase().startsWith('00002a00')) {
//           targetCharacteristic = characteristic;
//           break;
//         }
//       }
//       if (targetCharacteristic != null) break;
//     }
//
//     if (targetCharacteristic == null) {
//       throw Exception('No writable characteristic found for printer!');
//     }
//
//     final bytesToPrint = Uint8List.fromList(utf8.encode('Hello World\n\n\n'));
//     await targetCharacteristic.write(bytesToPrint, withoutResponse: true);
//
//     // 3. Send bytes (20 bytes per BLE packet)
//     // final chunks = chunkify(Uint8List.fromList(bytes), 20);
//     // for (var chunk in chunks) {
//     //   await targetCharacteristic.write(chunk, withoutResponse: true);
//     //   await Future.delayed(const Duration(milliseconds: 20)); // small delay
//     // }
//
//     print('✅ Printing done.');
//   } catch (e) {
//     print('❌ Print Error: $e');
//   }
// }

// Helper: Split bytes into chunks
List<List<int>> chunkify(Uint8List bytes, int chunkSize) {
  List<List<int>> chunks = [];
  for (var i = 0; i < bytes.length; i += chunkSize) {
    chunks.add(
      bytes.sublist(i, i + chunkSize > bytes.length ? bytes.length : i + chunkSize),
    );
  }
  return chunks;
}




Future<Uint8List?> generateEscPosCommand(Uint8List image) async {
  final esc = EscCommand();
  await esc.cleanCommand();

  await esc.image(image: image);
  await esc.cutPaper();
  return await esc.getCommand();
}

List<String> splitText(String text, int maxLength) {
  List<String> lines = [];
  while (text.isNotEmpty) {
    int endIndex = text.length > maxLength ? maxLength : text.length;
    lines.add(text.substring(0, endIndex));
    text = text.substring(endIndex);
  }
  return lines;
}

Future<void> generatePrintCommands80mm(List<PosProduct> products, escCommand) async {
  List<String> finalLines = [];

  // Header
  finalLines.add(
      'Product Name'.padRight(30) +
          'Qty'.padLeft(5) +
          'Price'.padLeft(7) +
          'Total'.padLeft(8)
  );
  finalLines.add('-' * 50); // separator line

  for (var product in products) {
    List<String> nameLines = splitText(product.name, 30); // 30 char for name

    for (int i = 0; i < nameLines.length; i++) {
      if (i == 0) {
        // First line: name + qty + price + total
        String line = nameLines[i].padRight(30) +
            product.qty.toString().padLeft(5) +
            product.unitPrice.toStringAsFixed(2).padLeft(7) +
            (product.qty * product.unitPrice).toStringAsFixed(2).padLeft(8);
        finalLines.add(line);
      } else {
        // Other lines: only product name continuation
        finalLines.add(nameLines[i]);
      }
    }
  }

  // Send to printer
  for (var line in finalLines) {
    await escCommand.text(content: line + "\n");
  }
}
