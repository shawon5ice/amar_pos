import 'package:amar_pos/core/data/model/reusable/customer_list_response_model.dart';
import 'package:amar_pos/features/exchange/exchange_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/model/reusable/service_person_response_model.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';
import '../../../../core/widgets/methods/field_validator.dart';
import 'package:get/get.dart';

import '../../../inventory/presentation/products/add_product_screen.dart';

class ExchangeSummary extends StatefulWidget {
  const ExchangeSummary({super.key});

  @override
  State<ExchangeSummary> createState() => _ExchangeSummaryState();
}

class _ExchangeSummaryState extends State<ExchangeSummary> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController customerNameEditingController;
  late final TextEditingController customerPhoneNumberEditingController;
  late final TextEditingController customerAddressEditingController;
  late final TextEditingController customerAdditionalExpensesEditingController;
  late final TextEditingController customerTotalDiscountEditingController;
  late final TextEditingController customerPayableAmountEditingController;
  late final TextEditingController customerChangeAmountEditingController;

  final ExchangeController controller = Get.find();

  @override
  void initState() {
    customerNameEditingController = TextEditingController();
    customerPhoneNumberEditingController = TextEditingController();
    customerAddressEditingController = TextEditingController();
    customerAdditionalExpensesEditingController = TextEditingController();
    customerTotalDiscountEditingController = TextEditingController();
    customerPayableAmountEditingController = TextEditingController();
    customerChangeAmountEditingController = TextEditingController();
    controller.calculateAmount(firstTime: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Form(
        key: formKey,
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
                    RichFieldTitle(text: "Customer Name",),
                    addH(4),
                    CustomTextField(
                      enabledFlag: controller.isRetailSale,
                      textCon: customerNameEditingController,
                      hintText: "Type customer name",
                      validator: (value) =>
                          FieldValidator.nonNullableFieldValidator(
                              value, "Customer name"),
                    ),
                    addH(8),
                    RichFieldTitle(text: "Phone Number",),
                    addH(4),
                    CustomTextField(
                      textCon: customerPhoneNumberEditingController,
                      hintText: "Type phone number",
                      validator: (value) =>
                          FieldValidator.nonNullableFieldValidator(
                              value, "Phone number"),
                    ),
                    addH(8),
                    RichFieldTitle(text: "Address",),
                    addH(4),
                    CustomTextField(
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
                    // ListView.builder(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: controller.paymentMethodTracker.length,
                    //   itemBuilder: (context, index) =>
                    //       ReturnSummaryPaymentOptionSelectionWidget(
                    //         key: ValueKey(controller.paymentMethodTracker[index]),
                    //         paymentMethodTracker:
                    //         controller.paymentMethodTracker[index],
                    //         onDeleteTap: (){
                    //           controller.paymentMethodTracker.removeAt(index);
                    //           controller.calculateAmount();
                    //         },
                    //       ),
                    // ),
                    // TextButton(
                    //   style: const ButtonStyle(
                    //       foregroundColor:
                    //       WidgetStatePropertyAll(AppColors.accent)),
                    //   child: const Text("Add Multiple payment method"),
                    //   onPressed: () {
                    //     controller.addPaymentMethod();
                    //   },
                    // ),
                    addH(8),
                    Row(
                      children: [
                        Expanded(
                          child: GetBuilder<ExchangeController>(
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
                          child: GetBuilder<ExchangeController>(
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

  final ExchangeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // controller.changeSellingParties(value);
        },
        child: Container(
          height: 40.sp,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.lightGreen),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              AutoSizeText(
                title,
                minFontSize: 8,
                maxFontSize: 14,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Radio(
                visualDensity: VisualDensity.compact,
                value: value,
                activeColor: const Color(0xff009D5D),
                groupValue: controller.isRetailSale,
                onChanged: (value) {
                  // controller.changeSellingParties(value!);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
