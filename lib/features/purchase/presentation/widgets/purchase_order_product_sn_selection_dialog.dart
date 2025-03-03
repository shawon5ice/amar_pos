import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../../../core/widgets/field_title.dart';
import '../../../../core/widgets/qr_code_scanner.dart';
import '../../../inventory/data/products/product_list_response_model.dart';

class PurchaseOrderProductSnSelectionDialog extends StatefulWidget {
  final PurchaseProductModel product;
  final ProductInfo productInfo;
  final PurchaseController controller;

  const PurchaseOrderProductSnSelectionDialog({
    super.key,
    required this.product,
    required this.productInfo,
    required this.controller,
  });

  @override
  State<PurchaseOrderProductSnSelectionDialog> createState() =>
      _PurchaseOrderProductSnSelectionDialogState();
}

class _PurchaseOrderProductSnSelectionDialogState
    extends State<PurchaseOrderProductSnSelectionDialog> {
  final PurchaseController controller = Get.find();
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

  void addSN(){
    String value = textEditingController.text;
    if(value.isEmpty){
      ErrorExtractor.showSingleErrorDialog(context, "Please insert a valid sn code");
      return;
    }

    for(int i = 0;i<widget.product.serialNo.length; i++){
      if(value == widget.product.serialNo[i]){
        ErrorExtractor.showSingleErrorDialog(context, "You've already added \"$value\" SN code");
        return;
      }
    }
    widget.product.serialNo.add(value);
    textEditingController.text = '';
    widget.controller.update(['purchase_order_product_sn_list','sn_input_field']);
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
                    GetBuilder<PurchaseController>(
                      id: 'sn_input_field',
                      builder: (controller) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 8,
                            child: CustomTextField(
                              enabledFlag: widget.product.quantity <=
                                  widget.product.serialNo.length
                                  ? false
                                  : true,
                              onSubmitted: (value) {
                                addSN();
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
                                      addSN();
                                    }
                                  },
                                  child: const Icon(
                                    Icons.qr_code_scanner_sharp,
                                    color: AppColors.accent,
                                  )),
                            ),
                          ),
                          addW(8),
                          Expanded(
                            flex: 2,
                            child: CustomButton(
                              radius: 8,
                              text: 'ADD',
                              onTap: (){
                                addSN();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<PurchaseController>(
                      id: 'purchase_order_product_sn_list',
                      builder: (controller) => widget.product.serialNo.isNotEmpty ? Column(
                        children: [
                          const DashedLine(),
                          const SizedBox(height: 8),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 150),
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 4,
                                children: widget.product.serialNo.reversed
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
                                        'purchase_order_product_sn_list',
                                        'sn_input_field'
                                      ]);
                                    },
                                  ),
                                )
                                    .toList(),
                              ),
                            ),
                          ),
                          addH(4),
                          DashedLine(),
                        ],
                      ) : SizedBox.shrink(),
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
