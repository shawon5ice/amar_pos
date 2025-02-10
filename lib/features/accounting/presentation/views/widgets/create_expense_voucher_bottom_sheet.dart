import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_categories_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/methods/field_validator.dart';

class CreateExpenseVoucherBottomSheet extends StatefulWidget {
  const CreateExpenseVoucherBottomSheet({super.key, this.category});

  final ExpenseCategory? category;

  @override
  State<CreateExpenseVoucherBottomSheet> createState() =>
      _CreateExpenseVoucherBottomSheetState();
}

class _CreateExpenseVoucherBottomSheetState
    extends State<CreateExpenseVoucherBottomSheet> {
  final ExpenseVoucherController _categoryController = Get.find();
  late TextEditingController _textEditingController;
  late TextEditingController _remarksEditingController;
  ExpenseCategory? selectedExpenseCategory;
  ExpensePaymentMethod? selectedExpensePaymentMethod;

  @override
  void initState() {
    _categoryController.getExpenseCategories(limit: 1000);
    _categoryController.getPaymentMethods();

    _textEditingController = TextEditingController();
    _remarksEditingController = TextEditingController();

    super.initState();
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
                      GetBuilder<ExpenseVoucherController>(
                        id: 'expense_category_dd',
                        builder: (controller) =>
                            CustomDropdownWithSearchWidget<ExpenseCategory>(
                          items: controller.expenseCategoriesList,
                          isMandatory: true,
                          title: "Category",
                          itemLabel: (expenseCategory) {
                            return expenseCategory.name;
                          },
                          onChanged: (expenseCategory) {
                            selectedExpenseCategory = expenseCategory;
                            if(selectedExpenseCategory != null){
                              _remarksEditingController.text = selectedExpenseCategory!.remarks ?? '';
                            }
                          },
                          hintText: "Select Expense Category",
                          searchHintText: "Search Expense Category",
                        ),
                      ),
                      addH(8),
                      Row(
                        children: [
                          Expanded(
                            child: GetBuilder<ExpenseVoucherController>(
                              id: 'expense_payment_methods_dd',
                              builder: (controller) =>
                                  CustomDropdownWithSearchWidget<ExpensePaymentMethod>(
                                    items: controller.expensePaymentMethods,
                                    isMandatory: true,
                                    title: "Payment Method",
                                    itemLabel: (paymentMethod) {
                                      return paymentMethod.name;
                                    },
                                    onChanged: (paymentMethod) {
                                      selectedExpensePaymentMethod = paymentMethod;
                                    },
                                    hintText: "Select Payment Method",
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
                  text: widget.category != null ? "Update" : "Add Now",
                  onTap: widget.category != null
                      ? () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            // _categoryController.editCategory(category: widget.category! ,categoryName: _textEditingController.text,);
                          }
                        }
                      : () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            _categoryController.addNewExpenseVoucher(
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
