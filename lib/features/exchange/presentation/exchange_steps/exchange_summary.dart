import 'package:amar_pos/features/exchange/exchange_controller.dart';
import 'package:amar_pos/features/exchange/presentation/widgets/exchange_summary_payment_option_selection_widget.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/model/reusable/service_person_response_model.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';
import '../../../../core/widgets/methods/field_validator.dart';
import 'package:get/get.dart';


class ExchangeSummary extends StatefulWidget {
  const ExchangeSummary({super.key});
  @override
  State<ExchangeSummary> createState() => _ExchangeSummaryState();
}

class _ExchangeSummaryState extends State<ExchangeSummary> {


  late final TextEditingController customerNameEditingController;
  late final TextEditingController customerPhoneNumberEditingController;
  late final TextEditingController customerAddressEditingController;
  late final TextEditingController customerTotalDiscountEditingController;
  late final TextEditingController customerPayableAmountEditingController;
  late final TextEditingController customerChangeAmountEditingController;

  final ExchangeController controller = Get.find();

  @override
  void initState() {
    customerNameEditingController = TextEditingController();
    customerPhoneNumberEditingController = TextEditingController();
    customerAddressEditingController = TextEditingController();
    customerTotalDiscountEditingController = TextEditingController();
    customerPayableAmountEditingController = TextEditingController();
    customerChangeAmountEditingController = TextEditingController();

    // if(!controller.isEditing){
    //   controller.clearPaymentAndOtherIssues();
    //   controller.getPaymentMethods();
    //   controller.addPaymentMethod(addForceFully: true);
    //   controller.calculateAmount(firstTime: true);
    // }else{
    //
    // }
    customerNameEditingController.text = controller.exchangeRequestModel.name;
    customerPhoneNumberEditingController.text = controller.exchangeRequestModel.phone;
    customerAddressEditingController.text = controller.exchangeRequestModel.address;
    customerTotalDiscountEditingController.text = controller.totalDiscount.toString();

    controller.calculateAmount(firstTime: true);
    if(controller.paymentMethodsResponseModel == null){
      controller.getPaymentMethods();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Form(
        key: controller.summaryFormKey,
        child: Column(
          children: [
            GetBuilder<ExchangeController>(
              id: "summary_form",
              builder: (controller) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const RichFieldTitle(text: "Customer Name",),
                    addH(4),
                    CustomTextField(
                      enabledFlag: controller.isRetailSale,
                      textCon: customerNameEditingController,
                      hintText: "Type customer name",
                      onChanged: (value){
                        controller.exchangeRequestModel.name = value;
                      },
                      validator: (value) =>
                          FieldValidator.nonNullableFieldValidator(
                              value, "Customer name"),
                    ),
                    addH(8),
                    const RichFieldTitle(text: "Phone Number",),
                    addH(4),
                    CustomTextField(
                      textCon: customerPhoneNumberEditingController,
                      hintText: "Type phone number",
                      onChanged: (value){
                        controller.exchangeRequestModel.phone = value;
                      },
                      validator: (value) =>
                          FieldValidator.nonNullableFieldValidator(
                              value, "Phone number"),
                    ),
                    addH(8),
                    const FieldTitle("Address",),
                    addH(4),
                    CustomTextField(
                      textCon: customerAddressEditingController,
                      hintText: "Type customer address",
                      onChanged: (value){
                        controller.exchangeRequestModel.address = value;
                      },
                      // validator: (value) =>
                      //     FieldValidator.nonNullableFieldValidator(
                      //         value, "Address"),
                    ),
                    addH(8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldTitle("Return QTY"),
                              addH(4),
                              CustomTextField(
                                enabledFlag: false,
                                textCon: TextEditingController(
                                    text: controller.totalReturnQTY.toString()),
                                hintText: "Return quantity",
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
                                    text: controller.totalReturnAmount.toString()),
                                hintText: "Type return amount",
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
                              const FieldTitle("Exchange QTY"),
                              addH(4),
                              CustomTextField(
                                enabledFlag: false,
                                textCon: TextEditingController(
                                    text: controller.totalExchangeQTY.toString()),
                                hintText: "Exchange quantity",
                              ),
                            ],
                          ),
                        ),
                        addW(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldTitle("Exchange Amount"),
                              addH(4),
                              CustomTextField(
                                enabledFlag: false,
                                textCon: TextEditingController(
                                    text: controller.totalExchangeAmount.toString()),
                                hintText: "Type exchange amount",
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
                                textCon: customerTotalDiscountEditingController,
                                hintText: "Type here",
                                inputType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    value = "0";
                                  }
                                  controller.totalDiscount = num.parse(value);
                                  controller.calculateAmount();
                                  controller.update(['summary_form']);
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
                          ExchangeSummaryPaymentOptionSelectionWidget(
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
                    addH(8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GetBuilder<ExchangeController>(
                              id: "change-due-amount",
                              builder: (controller) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FieldTitle("Change Amount"),
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
                          child: GetBuilder<ExchangeController>(
                            id: 'service_stuff_list',
                            builder: (controller) =>
                                CustomDropdownWithSearchWidget<ServiceStuffInfo>(
                                  searchHintText: "Type staff name...",
                                  value: controller.serviceStuffInfo,
                                  items: controller.serviceStuffList,
                                  isMandatory: false,
                                  title: "Service Staff",
                                  itemLabel: (ServiceStuffInfo stuffInfo) =>
                                  stuffInfo.name,
                                  onChanged: (value) {
                                    controller.serviceStuffInfo = value;
                                  },
                                  hintText:controller.serviceStuffListLoading? 'Loading...': controller.serviceStuffList.isNotEmpty
                                      ? "Select Service Staff"
                                      : "No Staff found!",
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
    );
  }
}