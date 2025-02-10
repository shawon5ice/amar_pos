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
import 'package:amar_pos/features/accounting/data/models/due_collection/due_collection_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_categories_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/methods/field_validator.dart';
import '../../../../../core/widgets/reusable/client_dd/client_dropdown_widget.dart';

class CreateDueCollectionBottomSheet extends StatefulWidget {
  const CreateDueCollectionBottomSheet({super.key, this.dueCollectionData});

  final DueCollectionData? dueCollectionData;

  @override
  State<CreateDueCollectionBottomSheet> createState() =>
      _CreateDueCollectionBottomSheetState();
}

class _CreateDueCollectionBottomSheetState
    extends State<CreateDueCollectionBottomSheet> {
  
  final DueCollectionController _dueCollectionController = Get.find();
  late TextEditingController _textEditingController;
  late TextEditingController _remarksEditingController;
  // ExpenseCategory? selectedExpenseCategory;
  ChartOfAccountPaymentMethod? selectedPaymentMethod;

  ClientInfo? selectedClient;

  Future<void> processData() async {
    // await _dueCollectionController.getExpenseCategories(limit: 1000);
    // await _dueCollectionController.getPaymentMethods();
  }

  @override
  void initState() {

    Get.put<ClientDDController>(ClientDDController());
    Get.put<CAPaymentMethodDDController>(CAPaymentMethodDDController());

    _textEditingController = TextEditingController();
    _remarksEditingController = TextEditingController();


    _remarksEditingController.text = widget.dueCollectionData?.remarks?? '';
    _textEditingController.text = widget.dueCollectionData?.amount.toString()?? '';
    if(widget.dueCollectionData != null){
      selectedClient = widget.dueCollectionData?.client;
      selectedPaymentMethod = widget.dueCollectionData?.paymentMethod;
    }

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ClientDDController>();
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
                  "Create Voucher",
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
                      ClientDropDownWidget(
                        initialClientInfo: widget.dueCollectionData?.client,
                        onClientSelection: (ClientInfo? client) {
                        selectedClient = client;
                        _dueCollectionController.update(['client_status_widget']);
                      },),
                      addH(8),
                      GetBuilder<DueCollectionController>(
                        id: 'client_status_widget',
                        builder: (controller) {
                          return selectedClient != null ? Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xffF6FBFF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xffE0E0E0)),
                            ),
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TitleValueStatusWidget(
                                  title: "Client Name: ",
                                  value: selectedClient!.name,
                                ),
                                TitleValueStatusWidget(
                                  title: "Phone Number: ",
                                  value: selectedClient!.phone,
                                ),
                                TitleValueStatusWidget(
                                  title: "Address: ",
                                  value: selectedClient!.address,
                                ),
                                TitleValueStatusWidget(
                                  title: "Previous Due: ",
                                  value: Methods.getFormatedPrice(
                                      selectedClient!.previousDue.toDouble()),
                                ),
                              ],
                            ),
                          ): SizedBox.shrink();
                        },
                      ),
                      addH(8),
                      Row(
                        children: [
                          Expanded(
                            child: CAPaymentMethodsDropDownWidget(
                              initialCAPaymentMethod: widget.dueCollectionData?.paymentMethod,
                              onCAPaymentMethodSelection: (ChartOfAccountPaymentMethod? method) {
                              selectedPaymentMethod = method;
                            },),
                          ),
                          addW(8),
                          
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const RichFieldTitle(text: "Paid Amount",),
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
                          ),)
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
                  text: widget.dueCollectionData != null ? "Update" : "Add Now",
                  onTap: widget.dueCollectionData != null
                      ? () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _dueCollectionController.updateExpenseVoucher(
                              id: widget.dueCollectionData!.id,
                                caID: selectedPaymentMethod!.id,
                                clientID: selectedClient!.id,
                                amount: num.parse(_textEditingController.text),
                                remarks: _remarksEditingController.text
                            );
                          }
                        }
                      : () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _dueCollectionController.addNewDueCollection(
                              clientID: selectedClient!.id,
                              caID: selectedPaymentMethod!.id,
                              amount: num.parse(_textEditingController.text),
                              remarks: _remarksEditingController.text
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
                style:const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 16.8 / 12,
                ),
              ),
              TextSpan(
                text: value,
                style:const TextStyle(
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
