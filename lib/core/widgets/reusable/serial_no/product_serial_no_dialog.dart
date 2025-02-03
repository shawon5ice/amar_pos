import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/reusable/serial_no/product_serial_no_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../../../core/widgets/field_title.dart';
import '../../../../core/widgets/qr_code_scanner.dart';
import 'package:get/get.dart';

class ProductSnSelectionDialog extends StatefulWidget {
  final String productName;
  final int quantity;

  const ProductSnSelectionDialog({
    super.key,
    required this.productName,
    required this.quantity,
  });

  @override
  State<ProductSnSelectionDialog> createState() =>
      _ProductSnSelectionDialogState();
}

class _ProductSnSelectionDialogState
    extends State<ProductSnSelectionDialog> {
  final ProductSerialNoController controller = Get.put(ProductSerialNoController());
  late final TextEditingController textEditingController;

  List<String> serialNo = [];

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    // Get<ProductSnSelectionDialog>.delete();
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
                      widget.productName,
                    ),
                    const SizedBox(height: 8),
                    const FieldTitle(
                      "Add Serial Number",
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<ProductSerialNoController>(
                      id: 'sn_input_field',
                      builder: (controller) => CustomTextField(
                        textCon: textEditingController,
                        hintText: 'Enter Serial No',
                        textInputAction: controller.serialNoList.length == widget.quantity - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                        onSubmitted: (value) => controller.handleSubmission(value,widget.quantity),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (controller.serialNoList.isNotEmpty)
                      Column(
                        children: [
                          const DashedLine(),
                          const SizedBox(height: 8),
                          GetBuilder<ProductSerialNoController>(
                            id: 'product_sn_list',
                            builder: (controller) => ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 150),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 4,
                                  children: controller.serialNoList
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
                                        controller.serialNoList.remove(e);
                                        controller.update([
                                          'product_sn_list',
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


InputDecoration _buildInputDecoration(bool enableField, suffixWidget) {
  return InputDecoration(
    filled: true,
    // fillColor: widget.enabledFlag ? widget.fillClr : widget.disableClr,
    contentPadding: const EdgeInsets.all(15),
    border: _getInputBorder(enableField),
    enabledBorder: _getInputBorder(enableField),
    focusedBorder: _getInputBorder(enableField),
    hintText: "Enter SN number",
    hintStyle: TextStyle(
      fontSize: 12,
      color: const Color(0xff909090),
      fontWeight: FontWeight.w500,
    ),
    suffixIcon: suffixWidget,
  );
}

InputBorder _getInputBorder(bool enabledFlag,) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(
      color: enabledFlag ? AppColors.primary : Colors.transparent,
      width: enabledFlag ? 1 : 0,
    ),
  );
}
