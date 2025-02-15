import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/data/model/reusable/supplier_list_response_model.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/exchange/exchange_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:amar_pos/features/purchase/presentation/widgets/purchase_summary_payment_option_selection_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/data/model/client_list_response_model.dart';
import '../../data/models/create_purchase_order_model.dart';

class PurchaseSummary extends StatefulWidget {
  const PurchaseSummary({super.key});

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

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Billing Summary"),
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
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: _textEditingController,
                                        searchInnerWidgetHeight: 48,
                                        searchInnerWidget: Padding(
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                          child: TextFormField(
                                            controller: _textEditingController,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: "Search Supplier",
                                              hintStyle: const TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          return item.value!.name
                                              .toLowerCase()
                                              .contains(searchValue.toLowerCase());
                                        },
                                      ),
                                      items: controller.supplierList
                                          .map((SupplierInfo item) {
                                        return DropdownMenuItem<SupplierInfo>(
                                          value: item,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.visible,
                                              ),
                                              Text(
                                                item.phone,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,

                                                ),
                                                overflow: TextOverflow.visible,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      value: controller.selectedSupplier,
                                      onChanged: (value) {
                                        if (value != null) {
                                          controller.selectedSupplier = value;
                                          customerPhoneNumberEditingController
                                              .text = value.phone ?? '';
                                          customerAddressEditingController.text =
                                              value.address ?? '';
                                          controller.update(['supplier_list']);
                                        }
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 56,
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.inputBorderColor),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                      ),
                                      dropdownStyleData: const DropdownStyleData(
                                        maxHeight: 300,
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
                        controller.updatePurchaseOrder();
                      }else{
                        controller.createPurchaseOrder();
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
}

