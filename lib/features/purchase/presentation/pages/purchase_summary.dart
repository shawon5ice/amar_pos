import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/data/model/reusable/supplier_list_response_model.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_history_details_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:amar_pos/features/purchase/presentation/widgets/purchase_summary_payment_option_selection_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/data/model/client_list_response_model.dart';
import '../../../../core/widgets/dashed_line.dart';
import '../../data/models/create_purchase_order_model.dart';

class PurchaseSummary extends StatefulWidget {
  PurchaseSummary({super.key,});

  @override
  State<PurchaseSummary> createState() => _PurchaseSummaryState();
}

class _PurchaseSummaryState extends State<PurchaseSummary> {
  late final TextEditingController customerNameEditingController;
  late final TextEditingController customerPhoneNumberEditingController;
  late final TextEditingController customerAddressEditingController;
  late final TextEditingController customerAdditionalExpensesEditingController;
  late final TextEditingController customerTotalDiscountEditingController;
  late final TextEditingController customerPayableAmountEditingController;
  late final TextEditingController customerChangeAmountEditingController;

  PurchaseController controller = Get.find();

  @override
  void initState() {
    suggestionEditingController = TextEditingController();
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
    suggestionEditingController.text = controller.selectedSupplier?.name ?? '';
    customerNameEditingController.text = controller.selectedSupplier?.name ?? '';
    customerPhoneNumberEditingController.text = controller.selectedSupplier?.phone ?? '';
    customerAddressEditingController.text = controller.selectedSupplier?.address ?? '';
    customerAdditionalExpensesEditingController.text = controller.additionalExpense.toString();
    customerTotalDiscountEditingController.text = controller.totalDiscount.toString();
    // else{
    //   customerNameEditingController.text = controller.createPurchaseOrderModel.name;
    //   customerPhoneNumberEditingController.text = controller.createPurchaseOrderModel.phone;
    //   customerAddressEditingController.text = controller.createPurchaseOrderModel.address;
    //   customerTotalDiscountEditingController.text = controller.saleHistoryDetailsResponseModel!.data.discount.toString();
    //   customerAdditionalExpensesEditingController.text = controller.saleHistoryDetailsResponseModel!.data.expense.toString();
    //   customerChangeAmountEditingController.text = controller.totalDeu.toString();
    // }


    controller.calculateAmount(firstTime: true);

    super.initState();
  }

  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    customerNameEditingController.dispose();
    customerPhoneNumberEditingController.dispose();
    customerAddressEditingController.dispose();
    customerAdditionalExpensesEditingController.dispose();
    customerTotalDiscountEditingController.dispose();
    customerPayableAmountEditingController.dispose();
    customerChangeAmountEditingController.dispose();
    super.dispose();
  }

  late TextEditingController suggestionEditingController;

  final formKey = GlobalKey<FormState>();

  List<double> _getCustomItemsHeights(items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Billing Summary",),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  GetBuilder<PurchaseController>(
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
                          GetBuilder<PurchaseController>(
                            id: 'supplier_list',
                            builder: (controller) => TypeAheadField<SupplierInfo>(
                              hideOnUnfocus: false,
                              hideOnSelect: true,
                              showOnFocus: true,
                              controller: suggestionEditingController,
                              builder: (context, textController, focusNode) {
                                suggestionEditingController = textController;
                                return TextFormField(
                                  autofocus: false,
                                  validator: (value) =>
                                      FieldValidator.nonNullableFieldValidator(
                                          value, "Supplier name"),
                                  controller: suggestionEditingController,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    border: _getInputBorder(),
                                    suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                    hintText: "Select Supplier",
                                    contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                    hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                );
                              },
                              suggestionsCallback: controller.supplierSuggestionsCallback,
                              itemBuilder: (context, supplier) {
                                return ListTile(
                                  minVerticalPadding: 4,
                                  isThreeLine: true,
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        supplier.name,
                                        style: const TextStyle(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(supplier.phone),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: DashedLine(),
                                  ),
                                );
                              },
                              onSelected: (value) {
                                controller.selectedSupplier = value;
                                suggestionEditingController.text = value.name;
                                customerNameEditingController.text = value.name ?? '';
                                customerPhoneNumberEditingController
                                    .text = value.phone ?? '';
                                customerAddressEditingController.text =
                                    value.address ?? '';
                                controller.update(['supplier_list']);
                                FocusScope.of(context).unfocus();
                              },

                              decorationBuilder: (context, child) {
                                return Material(
                                  type: MaterialType.card,
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  child: child,
                                );
                              },
                              offset: const Offset(0, 4),
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                              ),
                              emptyBuilder: (_) => const Center(
                                child: Text("No Items found!"),
                              ),
                              loadingBuilder: (_) => const Center(
                                child: CircularProgressIndicator(),
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
                          Column(
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
                          addH(8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const FieldTitle("Total Discount"),
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
                                    const FieldTitle("Payable Amount"),
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
                                PurchaseSummaryPaymentOptionSelectionWidget(
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
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.accent,
                child: GestureDetector(
                  child: SvgPicture.asset(
                    AppAssets.pauseBillingIcon,
                    color: Colors.white,
                  ),
                ),
              ),
              addW(12),
              Expanded(
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
                      controller.createPurchaseOrderModel.purchaseType = 1;
                      controller.createPurchaseOrderModel.supplierId = controller.selectedSupplier!.id;
                      controller.createPurchaseOrderModel.amount =
                          controller.totalAmount.toDouble();
                      controller.createPurchaseOrderModel.expense =
                          controller.additionalExpense.toDouble();
                      controller.createPurchaseOrderModel.discount =
                          controller.totalDiscount.toDouble();
                      controller.createPurchaseOrderModel.payable =
                          controller.paidAmount.toDouble();
                      controller.createPurchaseOrderModel.payments.clear();
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
                          controller.createPurchaseOrderModel.payments.add(Payment(
                              methodId: e.paymentMethod!.id,
                              paid: e.paidAmount!.toDouble(),
                              bankId: e.paymentOption?.id));
                        }
                      }
                      logger.d(controller.createPurchaseOrderModel.toJson());
                      if(controller.isEditing){
                        controller.updatePurchaseOrder().then((value){
                          if(value){
                            Get.to(const PurchaseHistoryDetailsView(),arguments: [controller.pOrderId, controller.pOrderNo]);
                          }

                        });
                      }else{
                        controller.createPurchaseOrder().then((value){
                          if(value){
                            Get.to(const PurchaseHistoryDetailsView(),arguments: [controller.pOrderId, controller.pOrderNo]);
                          }
                        });
                      }
                
                    }
                  },
                  text: controller.isEditing ? "Update Order" : "Purchase Now",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputBorder _getInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColors.inputBorderColor,
        width:  1,
      ),
    );
  }
}

