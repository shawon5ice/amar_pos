import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../../../core/widgets/field_title.dart';
import '../../../../core/widgets/qr_code_scanner.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import '../../data/models/create_order_model.dart';
import '../controller/sales_controller.dart';

class PlaceOrderProductSnSelectionDialog extends StatefulWidget {
  final SaleProductModel product;
  final ProductInfo productInfo;
  final SalesController controller;

  const PlaceOrderProductSnSelectionDialog({
    Key? key,
    required this.product,
    required this.productInfo,
    required this.controller,
  }) : super(key: key);

  @override
  State<PlaceOrderProductSnSelectionDialog> createState() =>
      _PlaceOrderProductSnSelectionDialogState();
}

class _PlaceOrderProductSnSelectionDialogState
    extends State<PlaceOrderProductSnSelectionDialog> {
  final SalesController controller = Get.find();
  late final TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Adjusts for keyboard
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "Add SN",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldTitle(
                      "Product Name",
                      fontWeight: FontWeight.bold,
                    ),
                    Text(
                      widget.productInfo.name,
                    ),
                    const SizedBox(height: 8),
                    const FieldTitle(
                      "Add Serial Number",
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<SalesController>(
                      id: 'sn_input_field',
                      builder: (controller) => CustomTextField(
                        enabledFlag: widget.product.quantity <=
                                widget.product.serialNo.length
                            ? false
                            : true,
                        onSubmitted: (value) {
                          widget.product.serialNo.add(value);
                          textEditingController.clear();
                          widget.controller
                              .update(['create_order_product_sn_list']);
                        },
                        textCon: textEditingController,
                        hintText: "Enter Serial Number",
                        suffixWidget: InkWell(
                            onTap: () async {
                              final String? scannedCode =
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const QRCodeScannerScreen(),
                                ),
                              );
                              if (scannedCode != null &&
                                  scannedCode.isNotEmpty) {
                                textEditingController.text = scannedCode;
                                widget.product.serialNo.add(scannedCode);
                                textEditingController.clear();
                                controller.update([
                                  'create_order_product_sn_list',
                                  'sn_input_field'
                                ]);
                              }
                            },
                            child: const Icon(
                              Icons.qr_code_scanner_sharp,
                              color: AppColors.accent,
                            )),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.product.serialNo.isNotEmpty)
                      Column(
                        children: [
                          const DashedLine(),
                          const SizedBox(height: 8),
                          GetBuilder<SalesController>(
                            id: 'create_order_product_sn_list',
                            builder: (controller) => ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 150),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 4,
                                  children: widget.product.serialNo
                                      .map(
                                        (e) => Chip(
                                          elevation: 4,
                                          label: Text(
                                            e,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp),
                                          ),
                                          onDeleted: () {
                                            widget.product.serialNo.remove(e);
                                            controller.update([
                                              'create_order_product_sn_list',
                                              'sn_input_field'
                                            ]);
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          addH(4),
                          DashedLine(),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Save",
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
