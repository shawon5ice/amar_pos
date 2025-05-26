import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dropdown_widget.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/supplier_dd/supplier_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/supplier_dd/supplier_dropdown_widget.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_payment/supplier_payment_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/supplier_payment_invoice_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../core/data/model/reusable/supplier_list_response_model.dart';

class MakeSupplierPaymentBottomSheet extends StatefulWidget {
  const MakeSupplierPaymentBottomSheet({super.key, this.supplierPayment});

  final SupplierPaymentData? supplierPayment;

  @override
  State<MakeSupplierPaymentBottomSheet> createState() =>
      __MakeSupplierPaymentBottomSheetState();
}

class __MakeSupplierPaymentBottomSheetState
    extends State<MakeSupplierPaymentBottomSheet> {
  final SupplierPaymentController _supplierPaymentController = Get.find();
  late TextEditingController _textEditingController;
  late TextEditingController _remarksEditingController;

  // ExpenseCategory? selectedExpenseCategory;
  ChartOfAccountPaymentMethod? selectedPaymentMethod;

  SupplierInfo? selectedSupplier;
  int? selectedSupplierId;

  Future<void> processData() async {
    // await _supplierPaymentController.getExpenseCategories(limit: 1000);
    // await _supplierPaymentController.getPaymentMethods();
  }

  ChartOfAccountPaymentMethod? chartOfAccountPaymentMethod;

  @override
  void initState() {
    Get.put<SupplierDDController>(SupplierDDController());
    Get.put<CAPaymentMethodDDController>(CAPaymentMethodDDController());

    _textEditingController = TextEditingController();
    _remarksEditingController = TextEditingController();

    _remarksEditingController.text = widget.supplierPayment?.remarks ?? '';
    _textEditingController.text =
        widget.supplierPayment?.amount.toString() ?? '';
    if (widget.supplierPayment != null) {
      chartOfAccountPaymentMethod = widget.supplierPayment?.paymentMethod;
      SupplierData supplierData = widget.supplierPayment!.supplier!;
      selectedSupplier = SupplierInfo(
          id: supplierData.id,
          name: supplierData.name,
          business: supplierData.business,
          code: supplierData.code,
          phone: supplierData.phone,
          openingBalance: supplierData.openingBalance,
          address: supplierData.address,
          photo: supplierData.photo,
          due: supplierData.due,
          status: supplierData.status);
      selectedSupplierId = widget.supplierPayment!.supplier?.id;
      selectedPaymentMethod = widget.supplierPayment?.paymentMethod;
    }

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SupplierDDController>();
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
                const Text(
                  "Supplier Payment",
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
                      // const FieldTitle(
                      //   "Category",
                      // ),
                      // addH(8),
                      SupplierDropDownWidget(
                        onSupplierSelection: (SupplierInfo? supplier) {
                          selectedSupplier = supplier;
                          selectedSupplierId = supplier?.id;
                          _supplierPaymentController
                              .update(['supplier_status_widget']);
                        },
                        initialSupplierInfo: selectedSupplier,
                      ),
                      addH(8),
                      GetBuilder<SupplierPaymentController>(
                        id: 'supplier_status_widget',
                        builder: (controller) {
                          return selectedSupplier != null
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF6FBFF),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xffE0E0E0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TitleValueStatusWidget(
                                        title: "Client Name: ",
                                        value: selectedSupplier!.name,
                                      ),
                                      TitleValueStatusWidget(
                                        title: "Phone Number: ",
                                        value: selectedSupplier!.phone,
                                      ),
                                      TitleValueStatusWidget(
                                        title: "Address: ",
                                        value: selectedSupplier!.address,
                                      ),
                                      TitleValueStatusWidget(
                                        title: "Previous Due: ",
                                        value: Methods.getFormatedPrice(
                                            selectedSupplier!.due.toDouble()),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      addH(8),
                      Row(
                        children: [
                          Expanded(
                            child: CAPaymentMethodsDropDownWidget(
                              initialCAPaymentMethod: selectedPaymentMethod,
                              onCAPaymentMethodSelection:
                                  (ChartOfAccountPaymentMethod? method) {
                                selectedPaymentMethod = method;
                              },
                            ),
                          ),
                          addW(8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const RichFieldTitle(
                                  text: "Paid Amount",
                                ),
                                addH(4),
                                CustomTextField(
                                  contentPadding: 16,
                                  inputType: TextInputType.number,
                                  textCon: _textEditingController,
                                  hintText: "Type amount",
                                  // height: 40,
                                  validator: (value) =>
                                      FieldValidator.nonNullableFieldValidator(
                                          value, "Paid Amount"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      addH(8),
                      const FieldTitle("Remarks"),
                      addH(4),
                      CustomTextField(
                        inputType: TextInputType.text,
                        textCon: _remarksEditingController,
                        hintText: "Type remarks",
                        maxLine: 3,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: widget.supplierPayment != null ? "Update" : "Pay Now",
                  onTap: widget.supplierPayment != null
                      ? () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _supplierPaymentController.updateSupplierPayment(
                                id: widget.supplierPayment!.id,
                                caID: selectedPaymentMethod!.id,
                                supplierID: selectedSupplier!.id,
                                amount: num.parse(_textEditingController.text),
                                remarks: _remarksEditingController.text);
                          }
                        }
                      : () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _supplierPaymentController.addNewSupplierPayment(
                                clientID: selectedSupplier!.id,
                                caID: selectedPaymentMethod!.id,
                                amount: num.parse(_textEditingController.text),
                                remarks: _remarksEditingController.text);
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
