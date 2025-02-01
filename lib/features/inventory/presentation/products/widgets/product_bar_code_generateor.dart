import 'dart:convert';
import 'package:amar_pos/core/widgets/dashed_line.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/inventory/data/products/product_list_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import '../../../../../core/core.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/field_title.dart';
import 'dart:ui' as ui;

class ProductBarCodeGenerator extends StatefulWidget {
  const ProductBarCodeGenerator({super.key});

  @override
  State<ProductBarCodeGenerator> createState() =>
      _ProductBarCodeGeneratorState();
}

class _ProductBarCodeGeneratorState extends State<ProductBarCodeGenerator> {
  final formKey = GlobalKey<FormState>();
  final ProductController controller = Get.find();
  late TextEditingController quantityEditorController;

  final GlobalKey _stickerKey = GlobalKey();

  ProductInfo? productInfo;
  int printPerRow = 3;
  int linePerPage = 7;
  bool pageMargin = false;

  @override
  void initState() {
    quantityEditorController = TextEditingController();
    productInfo = Get.arguments;
    super.initState();
  }

  @override
  void dispose() {
    quantityEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Generate Barcode"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalFieldTitleWithValue(
                        title: "Product Name",
                        value: productInfo!.name,
                      ),
                      addH(20),
                      VerticalFieldTitleWithValue(
                        title: "Product ID",
                        value: productInfo!.sku,
                      ),
                      addH(20),
                      CustomButton(
                        onTap: () {
                          controller.generateBarcode(
                            id: productInfo!.id,
                          );
                        },
                        color: AppColors.accent,
                        text: "Generate",
                      ),
                    ],
                  ),
                ),
                addH(50),
                GetBuilder<ProductController>(
                  id: "barcode_list",
                  builder: (controller) {
                    if (controller.barcodeGenerationLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (controller.generatedBarcode == "") {
                      return Center(child: Text("Barcode generation failed"));
                    } else {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            RepaintBoundary(
                              key: _stickerKey,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                    )),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 4),
                                child: Column(
                                  children: [
                                    Text(
                                      controller.loginData!.business.name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    addH(4),
                                    Text(
                                      productInfo!.name,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                    addH(12),
                                    SvgPicture.memory(
                                      Uint8List.fromList(base64Decode(controller
                                          .generatedBarcode
                                          .split(',')
                                          .last)),
                                      fit: BoxFit.contain,
                                    ),
                                    addH(4),
                                    Text(
                                      productInfo!.sku,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                    addH(8),
                                    Text(
                                      "MRP: ${Methods.getFormatedPrice(productInfo!.mrpPrice.toDouble())}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            addH(20),
                            DashedLine(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FieldTitle('Page Margin: '),
                                    Switch(
                                      value: pageMargin,
                                      onChanged: (value) {
                                        setState(() {
                                          pageMargin = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                CustomDropdown<int>(
                                  items: [1, 2, 3, 4, 5],
                                  isMandatory: false,
                                  value: printPerRow,
                                  title: "QR code per line",
                                  itemLabel: (item) => item.toString(),
                                  onChanged: (value) {
                                    if(value != null){
                                      printPerRow = value;
                                    }
                                  },
                                  hintText: "QR code per line",
                                ),
                                CustomDropdown<int>(
                                  items: [1, 2, 3, 4, 5,6,7,8,9,10],
                                  isMandatory: false,
                                  value: linePerPage,
                                  title: "Line per page",
                                  itemLabel: (item) => item.toString(),
                                  onChanged: (value) {
                                    if(value != null){
                                      linePerPage = value;
                                    }
                                  },
                                  hintText: "Line per page",
                                ),
                                // Slider(
                                //   value: printPerRow.toDouble(),
                                //   min: 1,
                                //   max: 5,
                                //   divisions: 4,
                                //   label: printPerRow.toInt().toString(),
                                //   onChanged: (double value) {
                                //     setState(() {
                                //       printPerRow = value.toInt();
                                //     });
                                //   },
                                // ),
                                // Text(
                                //   'Stickers per Row: ${printPerRow.toInt()}',
                                //   style: TextStyle(fontSize: 18),
                                // ),
                                // addH(20),
                                // Slider(
                                //   value: linePerPage.toDouble(),
                                //   min: 1,
                                //   max: 10,
                                //   divisions: 9,
                                //   label: linePerPage.toInt().toString(),
                                //   onChanged: (double value) {
                                //     setState(() {
                                //       linePerPage = value.toInt();
                                //     });
                                //   },
                                // ),
                                // Text(
                                //   'Line per page: ${linePerPage.toInt()}',
                                //   style: TextStyle(fontSize: 18),
                                // ),
                                const RichFieldTitle(
                                  text: "Quantity",
                                ),
                                addH(8),
                                Form(
                                  key: formKey,
                                  child: CustomTextField(
                                    textCon: quantityEditorController,
                                    hintText: "Type here...",
                                    inputType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) => FieldValidator
                                        .nonNullableFieldValidator(
                                      value,
                                      "quantity",
                                    ),
                                  ),
                                ),
                                addH(20),
                              ],
                            ),
                            CustomButton(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  _saveOrPrintSvg();
                                }
                              },
                              color: AppColors.primary,
                              text: "Print",
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveOrPrintSvg() async {
    final pdf = pw.Document();
    int stickersPerRow = printPerRow.toInt();
    int totalStickers = int.parse(quantityEditorController.text);
    int stickersPerPage =
        stickersPerRow * linePerPage; // Assume 10 rows per page
    int totalPages = (totalStickers / stickersPerPage).ceil();

    // Find the widget to capture
    final RenderRepaintBoundary boundary =
        _stickerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List imageBytes = byteData!.buffer.asUint8List();

    final pw.ImageProvider pdfImage = pw.MemoryImage(imageBytes);

    for (int page = 0; page < totalPages; page++) {
      pdf.addPage(
        pw.Page(
          margin: pageMargin ? null : pw.EdgeInsets.zero,
          build: (context) {
            return pw.GridView(
              crossAxisCount: stickersPerRow,
              padding: pw.EdgeInsets.all(8),
              children: List.generate(
                stickersPerPage,
                (index) {
                  int stickerIndex = page * stickersPerPage + index;
                  if (stickerIndex >= totalStickers) {
                    return pw.SizedBox();
                  }
                  return pw.Center(child: pw.Image(pdfImage));
                },
              ),
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
