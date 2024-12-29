import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/sales/data/models/payment_method_tracker.dart';
import 'package:amar_pos/features/sales/presentation/sales_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';
import '../../data/models/billing_payment_methods.dart';

class BillingSummaryPaymentOptionSelectionWidget extends StatefulWidget {
  const BillingSummaryPaymentOptionSelectionWidget(
      {super.key, required this.paymentMethodTracker,});

  final PaymentMethodTracker paymentMethodTracker;

  @override
  State<BillingSummaryPaymentOptionSelectionWidget> createState() =>
      _BillingSummaryPaymentOptionSelectionWidgetState();
}

class _BillingSummaryPaymentOptionSelectionWidgetState
    extends State<BillingSummaryPaymentOptionSelectionWidget> {
  PaymentMethod? paymentMethod;
  PaymentOption? paymentOption;

  late TextEditingController paidAmount;

  final SalesController controller = Get.find();

  @override
  void initState() {
    paidAmount = TextEditingController();
    paidAmount.text = widget.paymentMethodTracker.paidAmount.toString();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BillingSummaryPaymentOptionSelectionWidget oldWidget) {
    if(oldWidget.key != widget.key){
      paidAmount.text = "";
      controller.calculateAmount();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(
      key: Key(controller.paymentMethodTracker.indexOf(widget.paymentMethodTracker).toString()),
      id: "billing_payment_methods",
      builder: (controller) => Column(
        children: [
          addH(8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichFieldTitle(
                      text: "Payment Methods",
                    ),
                    addH(4),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<PaymentMethod>(
                        isExpanded: true,
                        hint: Text(
                          "Select Payment",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: controller.billingPaymentMethods?.data
                            .map((PaymentMethod item) {
                              return DropdownMenuItem<PaymentMethod>(
                                  value: item,
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                            })
                            .toList(),
                        value: widget.paymentMethodTracker.paymentMethod,
                        onChanged: (value) {
                          if (value != null) {
                            widget.paymentMethodTracker.paymentOption = null;
                            widget.paymentMethodTracker.paymentMethod = value;
                            controller.update(
                                ['billing_payment_methods', 'payments','billing_summary_form']);
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 48.sp,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.inputBorderColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                          offset: Offset(0, 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              addW(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldTitle("Paid Amount"),
                    addH(4),
                    CustomTextField(
                      readOnly: false,
                      textCon: paidAmount,
                      hintText: "Type here",
                      inputType: TextInputType.number,
                      onChanged: (value) {
                        if(value.isNotEmpty){
                          try{
                            widget.paymentMethodTracker.paidAmount = num.parse(value);
                            controller.calculateAmount();
                            controller.update(['change-due-amount']);
                          }catch(e){
                            Methods.showSnackbar(msg: "Please type a valid amount");
                          }
                        }else{
                          widget.paymentMethodTracker.paidAmount = 0;
                          controller.calculateAmount();
                          controller.update(['change-due-amount']);
                        }
                      },
                      validator: (value) {
                        try{
                          if(value != null && value.isNotEmpty){
                            var x = num.parse(value);
                          }
                        }catch(e){
                          return '⚠️ Please type a valid amount';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              addW(4),
              GestureDetector(onTap: (){
                FocusScope.of(context).unfocus();
                if(controller.paymentMethodTracker.length == 1){
                  widget.paymentMethodTracker.paidAmount = 0;
                  paidAmount.text = "";
                  controller.calculateAmount();
                }else {
                  controller.paymentMethodTracker.remove(widget.paymentMethodTracker);
                }

                // controller.deletePaymentMethod(widget.key!);
                controller.update(['billing_summary_form']);
              }, child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SvgPicture.asset(
                  AppAssets.deleteIc,
                  // Path to your SVG file
                  // height: 24,
                  width: 24,
                  color: Colors.red,
                ),
              ))
            ],
          ),
          widget.paymentMethodTracker.paymentMethod != null &&
                  widget.paymentMethodTracker.paymentMethod!.paymentOptions
                      .isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addH(8),
                    RichFieldTitle(
                      text: "Payment Options",
                    ),
                    addH(4),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<PaymentOption>(
                        isExpanded: true,
                        hint: Text(
                          "Select Payment Options",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: widget
                            .paymentMethodTracker.paymentMethod?.paymentOptions
                            .map((PaymentOption item) =>
                                DropdownMenuItem<PaymentOption>(
                                  value: item,
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: widget.paymentMethodTracker.paymentOption,
                        onChanged: (value) {
                          widget.paymentMethodTracker.paymentOption = value;
                          controller
                              .update(['billing_payment_methods', 'billing_summary_form']);
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 48,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.inputBorderColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                          offset: Offset(0, 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
