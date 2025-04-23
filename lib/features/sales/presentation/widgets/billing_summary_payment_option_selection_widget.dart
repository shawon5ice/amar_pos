import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/sales/data/models/payment_method_tracker.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/methods/number_input_formatter.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/field_title.dart';

class BillingSummaryPaymentOptionSelectionWidget extends StatefulWidget {
  BillingSummaryPaymentOptionSelectionWidget(
      {super.key, required this.paymentMethodTracker,required this.onDeleteTap});

  final void Function() onDeleteTap;
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

  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
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
  void dispose() {
    _textEditingController.dispose();
    paidAmount.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(
      key: Key(controller.paymentMethodTracker.indexOf(widget.paymentMethodTracker).toString()),
      id: "billing_payment_methods",
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 14.sp,
                    ),
                    addH(4),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<PaymentMethod>(
                        isExpanded: true,
                        hint: Text(
                          "Select Payment",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: controller.billingPaymentMethods?.data
                            .map((PaymentMethod item) {
                          return DropdownMenuItem<PaymentMethod>(
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
                        })
                            .toList(),
                        value: widget.paymentMethodTracker.paymentMethod,
                        onChanged: (value) {
                          if (value != null) {
                            if(value.name.toLowerCase().contains("cash") && controller.cashSelected || value.name.toLowerCase().contains("credit") && controller.creditSelected ){
                              Methods.showSnackbar(msg: "Please select another payment method");
                              return;
                            }
                            if(value.name.toLowerCase().contains("cash")){
                              controller.cashSelected =true;
                            }else if(value.name.toLowerCase().contains("credit")){
                              controller.creditSelected = true;
                            }
                            widget.paymentMethodTracker.paymentOption = null;
                            widget.paymentMethodTracker.paymentMethod = value;
                            controller.update(
                                ['billing_payment_methods', 'payments','return_summary_form']);
                            controller.calculateAmount();
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 56,
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
                          }catch(e){
                            Methods.showSnackbar(msg: "Please type a valid amount");
                          }
                        }else{
                          widget.paymentMethodTracker.paidAmount = 0;
                          controller.calculateAmount();
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
                  widget.paymentMethodTracker.paidAmount = 0;
                  widget.onDeleteTap();
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
              const RichFieldTitle(
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
                  items: widget
                      .paymentMethodTracker.paymentMethod?.paymentOptions
                      .map((PaymentOption item) =>
                      DropdownMenuItem<PaymentOption>(
                        value: item,
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                      .toList(),
                  value: widget.paymentMethodTracker.paymentOption,
                  onChanged: (value) {
                    for(int i=0;i<controller.paymentMethodTracker.length; i++){
                      if(controller.paymentMethodTracker[i].paymentOption?.id == value?.id ){
                        Methods.showSnackbar(msg: "Please select another bank");
                        return;
                      }
                    }
                    widget.paymentMethodTracker.paymentOption = value;
                    controller
                        .update(['billing_payment_methods', 'billing_summary_form']);
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 56,
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
