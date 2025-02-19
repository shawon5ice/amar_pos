import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/core/widgets/reusable/client_dd/client_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/client_dd/client_list_dd_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dropdown_widget.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_adjustment/money_adjustment_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/methods/field_validator.dart';
import '../../../data/models/money_adjustment_list_response_model/money_adjustment_list_response_model.dart';
import '../../../data/models/money_transfer/money_transfer_list_response_model.dart';
import '../money_transfer/money_transfer_controller.dart';

class MoneyAdjustmentBottomSheet extends StatefulWidget {
  const MoneyAdjustmentBottomSheet({super.key, this.moneyAdjustmentData});

  final MoneyAdjustmentData? moneyAdjustmentData;

  @override
  State<MoneyAdjustmentBottomSheet> createState() =>
      _MoneyAdjustmentBottomSheetState();
}

class _MoneyAdjustmentBottomSheetState extends State<MoneyAdjustmentBottomSheet> {
  final MoneyAdjustmentController _controller = Get.find();
  late TextEditingController _textEditingController;
  late TextEditingController _remarksEditingController;

  // ExpenseCategory? selectedExpenseCategory;
  ChartOfAccountPaymentMethod? selectedPaymentMethod;
  int? selectedPaymentMethodID;

  ClientInfo? selectedClient;

  Future<void> processData() async {
    selectedPaymentMethod = widget.moneyAdjustmentData!.paymentMethod;
  }
  

  @override
  void initState() {
    if(widget.moneyAdjustmentData != null){
      selectedPaymentMethod = widget.moneyAdjustmentData!.paymentMethod;
    }
    Get.put<CAPaymentMethodDDController>(CAPaymentMethodDDController());
    _textEditingController = TextEditingController();
    _remarksEditingController = TextEditingController();
    _remarksEditingController.text = widget.moneyAdjustmentData?.remarks ?? '';
    _textEditingController.text =
        widget.moneyAdjustmentData?.amount.toString() ?? '';


    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CAPaymentMethodDDController>();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();


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
          child: Form(
            key: formKey,
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
                Text(
                  _controller.adjustmentType == 1?  "Add Money" : "Withdraw Money",
                  style: const TextStyle(
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
                      CAPaymentMethodsDropDownWidget(
                        isMandatory: true,
                          initialCAPaymentMethod: selectedPaymentMethod,
                          onCAPaymentMethodSelection: (value){
                        selectedPaymentMethod = value;
                      }),
                      addH(8),
                      const RichFieldTitle(text: "Amount"),
                      addH(4),
                      CustomTextField(
                        inputType: TextInputType.number,
                        textCon: _textEditingController,
                        hintText: "Type amount",
                        validator: (value) => FieldValidator.nonNullableFieldValidator(value, "Amount"),
                      ),
                      addH(8),
                      const FieldTitle("Remarks"),
                      addH(4),
                      CustomTextField(
                        inputType: TextInputType.text,
                        textCon: _remarksEditingController,
                        hintText: "Type remarks",
                        maxLine: 2,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: widget.moneyAdjustmentData != null ? "Update" :  _controller.adjustmentType == 1?  "Add Now" : "Withdraw Now",
                  onTap: widget.moneyAdjustmentData != null
                      ? () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _controller.updateMoneyAdjustmentItem(
                              caID: selectedPaymentMethod!.id,
                              amount: num.parse(_textEditingController.text),
                              remarks: _remarksEditingController.text,
                              id: widget.moneyAdjustmentData!.id,
                            );
                          }
                        }
                      : () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _controller.storeNewMoneyAdjustment(
                              caID: selectedPaymentMethod!.id,
                              amount: num.parse(_textEditingController.text),
                              remarks: _remarksEditingController.text,
                            );
                          }
                        },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleValueStatusWidget extends StatelessWidget {
  const TitleValueStatusWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 16.8 / 12,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 16.8 / 12,
                ),
              ),
            ],
          ),
          softWrap: true,
        ),
        addH(4),
      ],
    );
  }
}
