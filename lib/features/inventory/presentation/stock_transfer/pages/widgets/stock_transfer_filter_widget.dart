import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/stock_transfer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../products/widgets/custom_drop_down_widget.dart';

class StockTransferFilterBottomSheetWidget extends StatefulWidget {
  StockTransferFilterBottomSheetWidget({
    super.key,
    required this.selectedDateTimeRange,
    required this.onSubmit,
  });

  DateTimeRange? selectedDateTimeRange;
  Function() onSubmit;

  @override
  State<StockTransferFilterBottomSheetWidget> createState() =>
      _StockTransferFilterBottomSheetWidgetState();
}

class _StockTransferFilterBottomSheetWidgetState
    extends State<StockTransferFilterBottomSheetWidget> {
  final StockTransferController _controller = Get.put(StockTransferController());

  late TextEditingController _dateTimeController;

  List<TransferType> transferTypes = [
    TransferType(typeName: "All"),
    TransferType(typeName: "Requisition",type: 1),
    TransferType(typeName: "Transfer",type: 2),
  ];

  TransferType? transferType;

  @override
  void initState() {
    _dateTimeController = TextEditingController();
    transferType = transferTypes.singleWhere((e) => e.type == _controller.transferType?.type);
    _controller.update(['type_dd']);
    _controller.selectedDateTimeRange.value = widget.selectedDateTimeRange;
    if(widget.selectedDateTimeRange != null){
      _dateTimeController.text = "${formatDate(widget.selectedDateTimeRange!.start)} - ${formatDate(widget.selectedDateTimeRange!.end)}";
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
        MediaQuery.of(context).viewInsets.bottom, // Adjusts for keyboard
      ),
      child: SingleChildScrollView(
        child: GetBuilder<StockTransferController>(
            id: 'filter_list',
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        "Filter",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldTitle('Date Range'),
                        addH(4),
                        GetBuilder<StockTransferController>(
                            id: 'date_time',
                            builder: (controller) {
                              return CustomTextField(
                                  readOnly: true,
                                  onTap: () async {
                                    DateTimeRange? selectedDate =
                                    await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 1000)),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 1000)),
                                      initialDateRange:
                                      controller.selectedDateTimeRange.value,
                                    );
                                    if (selectedDate != null) {
                                      controller.selectedDateTimeRange.value =
                                          selectedDate;
                                      _dateTimeController.text =
                                      "${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}";
                                      controller.update(['date_time']);
                                    }
                                  },
                                  suffixWidget:
                                  controller.selectedDateTimeRange.value != null
                                      ? IconButton(
                                      onPressed: () {
                                        controller.selectedDateTimeRange.value =
                                        null;
                                        _dateTimeController.clear();
                                        controller.update(['date_time']);
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color: AppColors.error,
                                      ))
                                      : const IconButton(
                                    onPressed: null,
                                    icon: Icon(Icons.calendar_month_outlined),
                                  ),
                                  textCon: _dateTimeController,
                                  txtSize: 12,
                                  hintText: "Select Date Range");
                            }),
                        addH(8),

                        GetBuilder<StockTransferController>(
                            id: 'type_dd',
                            builder: (controller) {
                              return CustomDropdownWithSearchWidget<TransferType>(
                                items: transferTypes,
                                isMandatory: false,
                                title: "Type",
                                filled: true,
                                // noTitle: true,
                                itemLabel: (value) => value.typeName ?? '',
                                value: transferType,
                                onChanged: (value) {
                                  controller.transferType = value;
                                  controller.update(['type_dd','filter_list']);
                                },
                                hintText: "Select Type",
                                searchHintText: "Search a type",
                              );
                            }),
                      ],
                    ),
                    addH(12),
                    CustomButton(
                      text: "Apply Filter",
                      radius: 8,
                      onTap: () {
                        // Get.back();
                        widget.onSubmit();
                      },
                    ),
                    addH(12),
                  ],
                ),
              );
            }),
      ),
    );
  }
}


class TransferType{
  int? type;
  String typeName;

  TransferType({this.type, required this.typeName});
}