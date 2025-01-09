import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'package:amar_pos/features/sales/data/models/client_list_response_model.dart';
import 'package:amar_pos/features/sales/data/models/create_order_model.dart';
import 'package:amar_pos/features/sales/data/models/service_person_response_model.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/billing_summary_payment_option_selection_widget.dart';

class BillingSummary extends StatefulWidget {
  const BillingSummary({super.key});

  @override
  State<BillingSummary> createState() => _BillingSummaryState();
}

class _BillingSummaryState extends State<BillingSummary> {
  late final TextEditingController customerNameEditingController;
  late final TextEditingController customerPhoneNumberEditingController;
  late final TextEditingController customerAddressEditingController;
  late final TextEditingController customerAdditionalExpensesEditingController;
  late final TextEditingController customerTotalDiscountEditingController;
  late final TextEditingController customerPayableAmountEditingController;
  late final TextEditingController customerChangeAmountEditingController;

  SalesController controller = Get.find();

  @override
  void initState() {
    controller.getAllServiceStuff();
    controller.getAllClientList();
    controller.serviceStuffInfo = null;
    controller.selectedClient = null;
    controller.isRetailSale = true;
    customerNameEditingController = TextEditingController();
    customerPhoneNumberEditingController = TextEditingController();
    customerAddressEditingController = TextEditingController();
    customerAdditionalExpensesEditingController = TextEditingController();
    customerTotalDiscountEditingController = TextEditingController();
    customerPayableAmountEditingController = TextEditingController();
    customerChangeAmountEditingController = TextEditingController();

    controller.calculateAmount(firstTime: true);
    controller.addPaymentMethod();
    controller.getPaymentMethods();

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
    controller.paymentMethodTracker.clear();
    controller.totalDiscount = 0;
    controller.additionalExpense = 0;
    controller.paidAmount = 0;
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                GetBuilder<SalesController>(
                  id: "selling_party_selection",
                  builder: (controller) => Row(
                    children: [
                      CustomRadioButton(
                        title: "Retail Sale",
                        value: true,
                      ),
                      addW(10),
                      CustomRadioButton(
                        title: "Wholesale",
                        value: false,
                      ),
                    ],
                  ),
                ),
                addH(12),
                GetBuilder<SalesController>(
                  id: "billing_summary_form",
                  builder: (controller) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FieldTitle(
                            "${controller.isRetailSale ? "Customer" : "Client"} Name"),
                        addH(4),
                        controller.isRetailSale
                            ? CustomTextField(
                                enabledFlag: controller.isRetailSale,
                                textCon: customerNameEditingController,
                                hintText: "Type customer name",
                                validator: (value) =>
                                    FieldValidator.nonNullableFieldValidator(
                                        value, "Customer name"),
                              )
                            : GetBuilder<SalesController>(
                                id: 'client_list',
                                builder: (controller) =>
                                    DropdownButtonHideUnderline(
                                  child: DropdownButton2<ClientData>(
                                    isExpanded: true,
                                    hint: Text(
                                      controller.clientList.isNotEmpty
                                          ? "Select Client"
                                          : "Loading...",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: controller.clientList
                                        .map((ClientData item) {
                                      return DropdownMenuItem<ClientData>(
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
                                    value: controller.selectedClient,
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectedClient = value;
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
                          enabledFlag: controller.isRetailSale,
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
                          enabledFlag: controller.isRetailSale,
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
                              BillingSummaryPaymentOptionSelectionWidget(
                            key: UniqueKey(),
                            paymentMethodTracker:
                                controller.paymentMethodTracker[index],
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
                        addH(8),
                        Row(
                          children: [
                            Expanded(
                              child: GetBuilder<SalesController>(
                                  id: "change-due-amount",
                                  builder: (controller) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          addH(16.h),
                                          FieldTitle(
                                              "${controller.totalDeu < 0 ? "Change" : "Deo"} Amount"),
                                          addH(4),
                                          CustomTextField(
                                            enabledFlag: false,
                                            textCon: TextEditingController(
                                                text: (controller.totalDeu)
                                                    .toString()),
                                            hintText: "Type here",
                                            inputType: TextInputType.number,
                                            onChanged: (value) {},
                                          ),
                                        ],
                                      )),
                            ),
                            addW(8),
                            Expanded(
                              child: GetBuilder<SalesController>(
                                id: 'service_stuff_list',
                                builder: (controller) =>
                                    CustomDropdown<ServiceStuffInfo>(
                                  validator: (value) => value == null
                                      ? "Please select a service stuff"
                                      : null,
                                  value: controller.serviceStuffInfo,
                                  items: controller.serviceStuffList,
                                  isMandatory: true,
                                  title: "Service Stuff",
                                  itemLabel: (ServiceStuffInfo stuffInfo) =>
                                      stuffInfo.name,
                                  onChanged: (value) {
                                    controller.serviceStuffInfo = value;
                                  },
                                  hintText:controller.serviceStuffListLoading? 'Loading...': controller.serviceStuffList.isNotEmpty
                                          ? "Select Service Stuff"
                                          : "No Stuff found!",
                                ),
                              ),
                            ),
                          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomButton(
          onTap: () {
            if (formKey.currentState!.validate()) {
              controller.createOrderModel.saleType =
                  controller.isRetailSale ? 1 : 2;
              if (!controller.isRetailSale &&
                  controller.selectedClient != null) {
                controller.createOrderModel.customerId =
                    controller.selectedClient!.id;
              }
              controller.createOrderModel.amount =
                  controller.totalAmount.toDouble();
              controller.createOrderModel.expense =
                  controller.additionalExpense.toDouble();
              controller.createOrderModel.discount =
                  controller.totalDiscount.toDouble();
              controller.createOrderModel.payable =
                  controller.paidAmount.toDouble();
              controller.createOrderModel.name = controller.isRetailSale
                  ? customerNameEditingController.text
                  : controller.selectedClient!.name;
              controller.createOrderModel.phone = controller.isRetailSale
                  ? customerPhoneNumberEditingController.text
                  : controller.selectedClient!.phone;
              controller.createOrderModel.address = controller.isRetailSale
                  ? customerAddressEditingController.text
                  : controller.selectedClient!.address;
              if (controller.serviceStuffInfo == null) {
                Methods.showSnackbar(msg: "Please select a service stuff");
                return;
              }
              controller.createOrderModel.serviceBy =
                  controller.serviceStuffInfo!.id;

              controller.createOrderModel.payments.clear();
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
                  controller.createOrderModel.payments.add(Payment(
                      methodId: e.paymentMethod!.id,
                      paid: e.paidAmount!.toDouble(),
                      bankId: e.paymentOption?.id));
                }
              }
              controller.createSaleOrder(context);
            }
          },
          text: "Place Order",
        ),
      ),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  CustomRadioButton({
    super.key,
    required this.title,
    required this.value,
    this.result,
  });

  final bool value;

  final String title;
  final Function()? result;

  final SalesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeSellingParties(value);
        },
        child: Container(
          height: 40.sp,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.lightGreen),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Radio(
                visualDensity: VisualDensity.compact,
                value: value,
                activeColor: const Color(0xff009D5D),
                groupValue: controller.isRetailSale,
                onChanged: (value) {
                  controller.changeSellingParties(value!);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
