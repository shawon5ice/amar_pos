
import 'package:amar_pos/core/data/model/outlet_model.dart';
import 'package:amar_pos/core/data/model/product_model.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/date_range_selection_field_widget.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dropdown_widget.dart';
import 'package:amar_pos/core/widgets/reusable/product_dd/products_dropdown_widget.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/stock_report_controller.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReturnHistoryFilterBottomSheet extends StatefulWidget {
  final bool saleHistory;
  const ReturnHistoryFilterBottomSheet({
    super.key,
    required this.saleHistory,
  });

  @override
  State<ReturnHistoryFilterBottomSheet> createState() =>
      _ProductListFilterBottomSheetState();
}

class _ProductListFilterBottomSheetState
    extends State<ReturnHistoryFilterBottomSheet> {
  ReturnController controller = Get.find();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Visibility(
                      visible: true,
                      child: TextButton(
                        onPressed: null,
                        child: const Text(
                          "",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: const Text(
                        "Filter",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: const ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(Colors.red)
                        ),
                        onPressed: (){
                          setState(() {
                            controller.clearFilter();
                          });
                        },
                        child: const Text(
                          "Clear",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                addH(10),
                Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          CustomDateRangeSelectionFieldWidget(
                            noInputBorder: true,
                            fontSize: 14,
                            onDateRangeSelection: controller.setSelectedDateRange,
                            initialDate: controller.selectedDateTimeRange.value,
                          ),
                          Divider(
                            height: 4,
                            color: Color(0xffB1B1B1),
                            thickness: .5,
                          ),
                          GetBuilder<ReturnController>(
                            id: 'filter_view',
                            builder: (controller) => Column(
                              children: [
                                Row(
                                  children: [
                                    addW(16),
                                    Text("Retail Sals", style: TextStyle(color: Color(0xff7C7C7C), fontSize: 14),),
                                    Spacer(),
                                    Checkbox(value: controller.retailSale, onChanged: (value){
                                      if(value != null){
                                        controller.retailSale = value;
                                        controller.update(['filter_view']);
                                      }
                                    })
                                  ],
                                ),
                                Divider(
                                  height: 4,
                                  color: Color(0xffB1B1B1),
                                  thickness: .5,
                                ),
                                Row(
                                  children: [
                                    addW(16),
                                    Text("Wholesal",style: TextStyle(color: Color(0xff7C7C7C), fontSize: 14),),
                                    Spacer(),
                                    Checkbox(value: controller.wholeSale, onChanged: (value){
                                      if(value != null){
                                        controller.wholeSale = value;
                                        controller.update(['filter_view']);
                                      }
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                addH(20),
                CustomButton(
                  text: "Apply",
                  onTap: () {
                    if(formKey.currentState!.validate()){
                      Get.back();
                      if(widget.saleHistory){
                        controller.getReturnHistory();
                      }else{
                        controller.getReturnProducts();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}