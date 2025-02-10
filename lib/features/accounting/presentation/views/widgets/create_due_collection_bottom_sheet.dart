import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/core/widgets/reusable/client_dd/client_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/client_dd/client_list_dd_response_model.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/features/accounting/data/models/due_collection/due_collection_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_categories_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/methods/field_validator.dart';
import '../../../../../core/widgets/reusable/client_dd/client_dropdown_widget.dart';
import '../../../data/models/expense_voucher/expense_voucher_response_model.dart';

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
  ExpenseCategory? selectedExpenseCategory;
  ExpensePaymentMethod? selectedExpensePaymentMethod;

  final outletDD = Get.put(OutletDDController());
  @override
  void initState() {

    // _dueCollectionController.getExpenseCategories(limit: 1000).then((value){
    //   if(widget.dueCollectionData != null){
    //     selectedExpenseCategory = _dueCollectionController.expenseCategoriesList.singleWhere((e) => e.id == widget.dueCollectionData!.category.id);
    //     _dueCollectionController.update(['expense_category_dd']);
    //   }
    // });
    // _dueCollectionController.getPaymentMethods().then((value){
    //   if(widget.dueCollectionData != null){
    //     selectedExpensePaymentMethod = _dueCollectionController.expensePaymentMethods.singleWhere((e) => e.id == widget.dueCollectionData!.paymentMethod.id);
    //     _dueCollectionController.update(['expense_payment_methods_dd']);
    //   }
    // });



    _textEditingController = TextEditingController();
    _remarksEditingController = TextEditingController();


    _remarksEditingController.text = widget.dueCollectionData?.remarks?? '';
    _textEditingController.text = widget.dueCollectionData?.amount.toString()?? '';

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ClientDDController>();
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
                      ClientDropDownWidget(onClientSelection: (ClientInfo? client) {

                      },),
                      addH(8),
                      Row(
                        children: [
                          Expanded(
                            child: GetBuilder<DueCollectionController>(
                              id: 'expense_payment_methods_dd',
                              builder: (controller) =>
                                  CustomDropdownWithSearchWidget<ExpensePaymentMethod>(
                                    items: controller.expensePaymentMethods,
                                    isMandatory: true,
                                    title: "Payment Method",
                                    value: selectedExpensePaymentMethod,
                                    itemLabel: (paymentMethod) {
                                      return paymentMethod.name;
                                    },
                                    onChanged: (paymentMethod) {
                                      selectedExpensePaymentMethod = paymentMethod;
                                    },
                                    hintText: controller.isExpensePaymentMethodsListLoading? "Loading...": "Select Payment Method",
                                    searchHintText: "Search Payment Method",
                                  ),
                            ),
                          ),
                          addW(8),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const RichFieldTitle(text: "Amount",),
                              addH(4),
                              CustomTextField(
                                inputType: TextInputType.number,
                                textCon: _textEditingController,
                                hintText: "Type amount",
                                // height: 40,
                                validator: (value) =>
                                    FieldValidator.nonNullableFieldValidator(
                                        value, "amount"),
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
                                categoryID: selectedExpenseCategory!.id,
                                caID: selectedExpensePaymentMethod!.id,
                                amount: num.parse(_textEditingController.text),
                                remarks: _remarksEditingController.text
                            );
                          }
                        }
                      : () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _dueCollectionController.addNewExpenseVoucher(
                              categoryID: selectedExpenseCategory!.id,
                              caID: selectedExpensePaymentMethod!.id,
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
