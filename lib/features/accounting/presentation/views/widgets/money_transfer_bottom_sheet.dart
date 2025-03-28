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
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/methods/field_validator.dart';
import '../../../data/models/money_transfer/money_transfer_list_response_model.dart';
import '../money_transfer/money_transfer_controller.dart';

class MoneyTransferBottomSheet extends StatefulWidget {
  const MoneyTransferBottomSheet({super.key, this.moneyTransferData});

  final MoneyTransferData? moneyTransferData;

  @override
  State<MoneyTransferBottomSheet> createState() =>
      _MoneyTransferBottomSheetState();
}

class _MoneyTransferBottomSheetState extends State<MoneyTransferBottomSheet> {
  final MoneyTransferController _controller = Get.find();
  late TextEditingController _textEditingController;
  late TextEditingController _remarksEditingController;

  // ExpenseCategory? selectedExpenseCategory;
  ChartOfAccountPaymentMethod? selectedPaymentMethod;
  int? selectedPaymentMethodID;

  ClientInfo? selectedClient;

  Future<void> processData() async {
    // await _controller.getExpenseCategories(limit: 1000);
    // await _controller.getPaymentMethods();
  }

  OutletForMoneyTransferData? selectedFromOutlet;
  OutletForMoneyTransferData? selectedToOutlet;
  OutletForMoneyTransferData? selectedFromAccount;

  @override
  void initState() {

    _textEditingController = TextEditingController();
    _remarksEditingController = TextEditingController();
    setup();
    _remarksEditingController.text = widget.moneyTransferData?.remarks ?? '';
    _textEditingController.text =
        widget.moneyTransferData?.amount.toString() ?? '';


    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();


  Future<void> setup() async{
    await _controller.getOutletForMoneyTransferList().then((value){
      if(widget.moneyTransferData != null){
        selectedFromAccount = _controller.outletListForMoneyTransferResponseModel!.data!.fromAccounts!.singleWhere((e) => e.id == widget.moneyTransferData!.fromAccount!.id);
        selectedFromOutlet = _controller.outletListForMoneyTransferResponseModel!.data!.fromStores!.singleWhere((e) => e.id == widget.moneyTransferData!.fromStore!.id);
        selectedToOutlet = _controller.outletListForMoneyTransferResponseModel!.data!.toStores!.singleWhere((e) => e.id == widget.moneyTransferData!.toStore!.id);
        selectedPaymentMethodID = widget.moneyTransferData!.toAccount!.id;
        logger.i(selectedPaymentMethodID);
        _controller.update(['outlet_list_for_money_transfer']);
      }
    });

   await _controller.getAllPaymentMethods(account: selectedPaymentMethod, id: selectedPaymentMethodID).then((e){
     selectedPaymentMethod = _controller.paymentList.singleWhere((e) => e.id == selectedPaymentMethodID);
     _controller.update(['ca_payment_dd']);
   });

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
                  "Money Transfer",
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
                      GetBuilder<MoneyTransferController>(
                        id: 'outlet_list_for_money_transfer',
                        builder: (controller) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addH(8),
                            CustomDropdownWithSearchWidget<OutletForMoneyTransferData>(
                              items: controller.outletListLoading ||
                                  controller.outletListForMoneyTransferResponseModel == null
                                  ? []
                                  : controller.outletListForMoneyTransferResponseModel!.data!.fromStores!,
                              isMandatory: true,
                              title: "From Outlet",
                              // noTitle: true,
                              itemLabel: (value) => value.name,
                              value: selectedFromOutlet,
                              onChanged: (value) {
                                selectedFromOutlet = value;
                              },
                              hintText: controller.outletListLoading
                                  ? "Loading..."
                                  : controller.outletListForMoneyTransferResponseModel == null ||
                                  (controller.outletListForMoneyTransferResponseModel !=
                                      null &&
                                      controller.outletListForMoneyTransferResponseModel!
                                          .data ==
                                          null)
                                  ? "No outlet found"
                                  : "Select outlet",
                              searchHintText: "Search an outlet",
                              validator: (value) => FieldValidator.nonNullableFieldValidator(
                                  value?.name, "From outlet"),
                            ),
                            addH(8),
                            CustomDropdownWithSearchWidget<OutletForMoneyTransferData>(
                              items: controller.outletListLoading ||
                                  controller.outletListForMoneyTransferResponseModel == null
                                  ? []
                                  : controller.outletListForMoneyTransferResponseModel!.data!.fromAccounts!,
                              isMandatory: true,
                              title: "From Account",
                              // noTitle: true,
                              itemLabel: (value) => value.name,
                              value: selectedFromAccount,
                              onChanged: (value) {
                                selectedFromAccount = value;
                              },
                              hintText: controller.outletListLoading
                                  ? "Loading..."
                                  : controller.outletListForMoneyTransferResponseModel == null ||
                                  (controller.outletListForMoneyTransferResponseModel !=
                                      null &&
                                      controller.outletListForMoneyTransferResponseModel!
                                          .data ==
                                          null)
                                  ? "No account found"
                                  : "Select account",
                              searchHintText: "Search an account",
                              validator: (value) => FieldValidator.nonNullableFieldValidator(
                                  value?.name, "From account"),
                            ),
                            addH(8),
                            CustomDropdownWithSearchWidget<OutletForMoneyTransferData>(
                              items: controller.outletListLoading ||
                                  controller.outletListForMoneyTransferResponseModel == null
                                  ? []
                                  : controller.outletListForMoneyTransferResponseModel!.data!.toStores!,
                              isMandatory: true,
                              title: "To Outlet",
                              // noTitle: true,
                              itemLabel: (value) => value.name,
                              value: selectedToOutlet,
                              onChanged: (value) {
                                selectedToOutlet = value;
                              },
                              hintText: controller.outletListLoading
                                  ? "Loading..."
                                  : controller.outletListForMoneyTransferResponseModel == null ||
                                  (controller.outletListForMoneyTransferResponseModel !=
                                      null &&
                                      controller.outletListForMoneyTransferResponseModel!
                                          .data ==
                                          null)
                                  ? "No outlet found"
                                  : "Select outlet",
                              searchHintText: "Search an outlet",
                              validator: (value) => FieldValidator.nonNullableFieldValidator(
                                  value?.name, "To outlet"),
                            ),
                            addH(8)
                          ],
                        ),
                      ),
                      GetBuilder<MoneyTransferController>(
                          id: 'ca_payment_dd',
                          builder: (controller) {
                            return CustomDropdownWithSearchWidget<
                                ChartOfAccountPaymentMethod>(
                              items: controller.paymentList,
                              isMandatory: true,
                              title: "To Account",
                              // noTitle: true,
                              itemLabel: (value) => value.name,
                              value: selectedPaymentMethod,
                              onChanged: (value) {
                                selectedPaymentMethod = value;
                                controller.update([
                                  'ca_payment_dd'
                                ]); // Notify UI of the change
                              },
                              hintText: controller.paymentListLoading
                                  ? "Loading..."
                                  : controller.paymentList.isEmpty
                                  ? "No payment method found..."
                                  : "Select ao account",
                              searchHintText: "Search a payment method",
                              validator: (value) =>
                                  FieldValidator.nonNullableFieldValidator(
                                      value?.name, "To Account"),
                            );
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
                  text: widget.moneyTransferData != null ? "Update" : "Add Now",
                  onTap: widget.moneyTransferData != null
                      ? () {
                          if (formKey.currentState!.validate()) {
                            Get.back();

                            _controller.updateMoneyTransferItem(
                              id: widget.moneyTransferData!.id,
                              fromStoreID: selectedFromOutlet!.id,
                              toStoreID: selectedToOutlet!.id,
                              toAccountID: selectedPaymentMethod!.id,
                              fromAccountID: selectedFromAccount!.id,
                              amount: num.parse(_textEditingController.text),
                              remarks: _remarksEditingController.text,
                            );
                          }
                        }
                      : () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _controller.storeNewMoneyTransfer(
                              fromStoreID: selectedFromOutlet!.id,
                              toStoreID: selectedToOutlet!.id,
                              toAccountID: selectedPaymentMethod!.id,
                              fromAccountID: selectedFromAccount!.id,
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
