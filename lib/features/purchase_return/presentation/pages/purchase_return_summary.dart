import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/data/model/reusable/supplier_list_response_model.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/purchase_return/presentation/purchase_return_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/create_purchase_return_order_model.dart';
import '../widgets/purchase_return_summary_payment_option_selection_widget.dart';


class PurchaseReturnSummary extends StatefulWidget {
  const PurchaseReturnSummary({super.key});

  @override
  State<PurchaseReturnSummary> createState() => _PurchaseReturnSummaryState();
}

class _PurchaseReturnSummaryState extends State<PurchaseReturnSummary> {
  late final TextEditingController customerNameEditingController;
  late final TextEditingController customerPhoneNumberEditingController;
  late final TextEditingController customerAddressEditingController;
  late final TextEditingController customerAdditionalExpensesEditingController;
  late final TextEditingController customerTotalDiscountEditingController;
  late final TextEditingController customerPayableAmountEditingController;
  late final TextEditingController customerChangeAmountEditingController;

  PurchaseReturnController controller = Get.find();

  @override
  void initState() {

    customerNameEditingController = TextEditingController();
    customerPhoneNumberEditingController = TextEditingController();
    customerAddressEditingController = TextEditingController();
    customerAdditionalExpensesEditingController = TextEditingController();
    customerTotalDiscountEditingController = TextEditingController();
    customerPayableAmountEditingController = TextEditingController();
    customerChangeAmountEditingController = TextEditingController();

    if(controller.supplierList.isEmpty){
      controller.getAllSupplierList();
    }
    // if(controller.serviceStuffList.isEmpty){
    //   controller.getAllServiceStuff();
    // }
    if(controller.purchasePaymentMethods == null){
      controller.getPaymentMethods();
    }

    customerNameEditingController.text = controller.selectedSupplier?.name ?? '';
    customerPhoneNumberEditingController.text = controller.selectedSupplier?.phone ?? '';
    customerAddressEditingController.text = controller.selectedSupplier?.address ?? '';
    customerAdditionalExpensesEditingController.text = controller.additionalExpense.toString();
    customerTotalDiscountEditingController.text = controller.totalDiscount.toString();
    // else{
    //   customerNameEditingController.text = controller.createPurchaseReturnOrderModel.name;
    //   customerPhoneNumberEditingController.text = controller.createPurchaseReturnOrderModel.phone;
    //   customerAddressEditingController.text = controller.createPurchaseReturnOrderModel.address;
    //   customerTotalDiscountEditingController.text = controller.saleHistoryDetailsResponseModel!.data.discount.toString();
    //   customerAdditionalExpensesEditingController.text = controller.saleHistoryDetailsResponseModel!.data.expense.toString();
    //   customerChangeAmountEditingController.text = controller.totalDeu.toString();
    // }



    controller.calculateAmount(firstTime: true);

    super.initState();
  }

  @override
  void dispose() {
    customerNameEditingController.dispose();
    customerPhoneNumberEditingController.dispose();
    customerAddressEditingController.dispose();
    customerAdditionalExpensesEditingController.dispose();
    customerTotalDiscountEditingController.dispose();
    customerPayableAmountEditingController.dispose();
    customerChangeAmountEditingController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Return Summary"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GetBuilder<PurchaseReturnController>(
                  id: "billing_summary_form",
                  builder: (controller) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FieldTitle("Supplier Name"),
                        addH(4),
                        GetBuilder<PurchaseReturnController>(
                                id: 'supplier_list',
                                builder: (controller) =>
                                    DropdownButtonHideUnderline(
                                  child: DropdownButton2<SupplierInfo>(
                                    isExpanded: true,
                                    hint: Text(
                                      controller.supplierList.isNotEmpty
                                          ? "Select Supplier"
                                          : "Loading...",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: controller.supplierList
                                        .map((SupplierInfo item) {
                                      return DropdownMenuItem<SupplierInfo>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    value: controller.selectedSupplier,
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectedSupplier = value;
                                        customerPhoneNumberEditingController
                                            .text = value.phone;
                                        customerAddressEditingController.text =
                                            value.address;
                                        controller.update(['client_list']);
                                      }
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 56.sp,
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.inputBorderColor),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                      offset: Offset(0, 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ),
                        addH(8),
                        const FieldTitle("Phone Number"),
                        addH(4),
                        CustomTextField(
                          enabledFlag: false,
                          textCon: customerPhoneNumberEditingController,
                          hintText: "Type phone number",
                          validator: (value) =>
                              FieldValidator.nonNullableFieldValidator(
                                  value, "Phone number"),
                        ),
                        addH(8),
                        const FieldTitle("Address"),
                        addH(4),
                        CustomTextField(
                          enabledFlag: false,
                          textCon: customerAddressEditingController,
                          hintText: "Type customer address",
                          validator: (value) =>
                              FieldValidator.nonNullableFieldValidator(
                                  value, "Address"),
                        ),
                        addH(8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldTitle("Total QTY"),
                                  addH(4),
                                  CustomTextField(
                                    enabledFlag: false,
                                    textCon: TextEditingController(
                                        text: controller.totalQTY.toString()),
                                    hintText: "Total quantity",
                                  ),
                                ],
                              ),
                            ),
                            addW(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldTitle("Total Amount"),
                                  addH(4),
                                  CustomTextField(
                                    enabledFlag: false,
                                    textCon: TextEditingController(
                                        text:
                                            controller.totalAmount.toString()),
                                    hintText: "Type total amount",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        addH(8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldTitle("Additional expenses"),
                                  addH(4),
                                  CustomTextField(
                                    textCon:
                                        customerAdditionalExpensesEditingController,
                                    hintText: "Type here",
                                    inputType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        value = "0";
                                      }
                                      controller.additionalExpense =
                                          num.parse(value);
                                      controller.calculateAmount();
                                      controller
                                          .update(['billing_summary_form']);
                                    },
                                    validator: (value) {
                                      try {
                                        if (value != null && value.isNotEmpty) {
                                          var x = num.parse(value);
                                        }
                                      } catch (e) {
                                        return '⚠️ Please type a valid amount';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            addW(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldTitle("VAT"),
                                  addH(4),
                                  CustomTextField(
                                    enabledFlag: false,
                                    textCon: TextEditingController(
                                        text: controller.totalVat.toString()),
                                    hintText: "VAT",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        addH(8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldTitle("Deduction"),
                                  addH(4),
                                  CustomTextField(
                                    textCon:
                                        customerTotalDiscountEditingController,
                                    hintText: "Type here",
                                    inputType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        value = "0";
                                      }
                                      controller.totalDiscount =
                                          num.parse(value);
                                      controller.calculateAmount();
                                      controller
                                          .update(['billing_summary_form']);
                                    },
                                    validator: (value) {
                                      try {
                                        if (value != null && value.isNotEmpty) {
                                          var x = num.parse(value);
                                        }
                                      } catch (e) {
                                        return '⚠️ Please type a valid amount';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            addW(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FieldTitle("Return Amount"),
                                  addH(4),
                                  CustomTextField(
                                    enabledFlag: false,
                                    textCon: TextEditingController(
                                        text: controller.paidAmount.toString()),
                                    hintText: "Type here",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        addH(8),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.paymentMethodTracker.length,
                          itemBuilder: (context, index) =>
                              PurchaseReturnSummaryPaymentOptionSelectionWidget(
                            key: ValueKey(controller.paymentMethodTracker[index]),
                            paymentMethodTracker:
                                controller.paymentMethodTracker[index],
                                onDeleteTap: (){
                                  controller.paymentMethodTracker.removeAt(index);
                                  controller.calculateAmount();
                                },
                          ),
                        ),
                        TextButton(
                          style: const ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(AppColors.accent)),
                          child: const Text("Add Multiple payment method"),
                          onPressed: () {
                            controller.addPaymentMethod();
                          },
                        ),
                        // addH(8),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: GetBuilder<PurchaseReturnController>(
                        //           id: "change-due-amount",
                        //           builder: (controller) => Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   addH(16.h),
                        //                   const FieldTitle("Change Amount"),
                        //                   addH(4),
                        //                   CustomTextField(
                        //                     enabledFlag: false,
                        //                     textCon: TextEditingController(
                        //                         text: (controller.totalDeu)
                        //                             .toString()),
                        //                     hintText: "Type here",
                        //                     inputType: TextInputType.number,
                        //                     onChanged: (value) {},
                        //                   ),
                        //                 ],
                        //               )),
                        //     ),
                        //     addW(8),
                        //     Expanded(
                        //       child: GetBuilder<PurchaseReturnController>(
                        //         id: 'service_stuff_list',
                        //         builder: (controller) =>
                        //             CustomDropdown<ServiceStuffInfo>(
                        //           validator: (value) => value == null
                        //               ? "Please select a service stuff"
                        //               : null,
                        //           value: controller.serviceStuffInfo,
                        //           items: controller.serviceStuffList,
                        //           isMandatory: true,
                        //           title: "Service Stuff",
                        //           itemLabel: (ServiceStuffInfo stuffInfo) =>
                        //               stuffInfo.name,
                        //           onChanged: (value) {
                        //             controller.serviceStuffInfo = value;
                        //           },
                        //           hintText:controller.serviceStuffListLoading? 'Loading...': controller.serviceStuffList.isNotEmpty
                        //                   ? "Select Service Stuff"
                        //                   : "No Stuff found!",
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomButton(
          onTap: () {
            if(controller.selectedSupplier == null){
              Methods.showSnackbar(msg: "Please select a supplier first");
              return;
            }
            if(controller.totalPaid != controller.paidAmount){
              Methods.showSnackbar(msg: "Paid amount must be equal to payable amount", duration: 5);
              return;
            }
            if (formKey.currentState!.validate()) {
              controller.createPurchaseReturnOrderModel.purchaseType = 2;
              controller.createPurchaseReturnOrderModel.supplierId = controller.selectedSupplier!.id;
              controller.createPurchaseReturnOrderModel.amount =
                  controller.totalAmount.toDouble();
              controller.createPurchaseReturnOrderModel.expense =
                  controller.additionalExpense.toDouble();
              controller.createPurchaseReturnOrderModel.discount =
                  controller.totalDiscount.toDouble();
              controller.createPurchaseReturnOrderModel.payable =
                  controller.paidAmount.toDouble();
              controller.createPurchaseReturnOrderModel.payments.clear();
              for (var e in controller.paymentMethodTracker) {
                if (e.paymentMethod == null) {
                  Methods.showSnackbar(
                      msg:
                          "Please insert valid amount or remove not selected payment methods");
                  return;
                } else if (e.paymentMethod != null &&
                    e.paymentMethod!.paymentOptions.isNotEmpty &&
                    e.paymentOption == null) {
                  Methods.showSnackbar(
                      msg: "Please select associate payment options");
                  return;
                } else {
                  controller.createPurchaseReturnOrderModel.payments.add(Payment(
                      methodId: e.paymentMethod!.id,
                      paid: e.paidAmount!.toDouble(),
                      bankId: e.paymentOption?.id));
                }
              }
              logger.d(controller.createPurchaseReturnOrderModel.toJson());
              if(controller.isEditing){
                controller.updatePurchaseOrder();
              }else{
                controller.createPurchaseReturnOrder();
              }

            }
          },
          text: controller.isEditing ? "Update Return" : "Process Return",
        ),
      ),
    );
  }
}

