import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dropdown_widget.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/stock_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/date_selection_field_widget.dart';

class StockLedgerFilterBottomSheet extends StatefulWidget {
  const StockLedgerFilterBottomSheet({
    super.key,
  });

  @override
  State<StockLedgerFilterBottomSheet> createState() =>
      _ProductListFilterBottomSheetState();
}

class _ProductListFilterBottomSheetState
    extends State<StockLedgerFilterBottomSheet> {
  StockReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "Filter",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: OutletDropDownWidget(),
                            ),
                            addW(10),
                            Expanded(
                              flex: 4,
                              child: CustomTextField(
                                txtSize: 14,
                                readOnly: true,
                                onTap: () async {
                                  DateTimeRange? selectedDate = await showDateRangePicker(
                                    saveText: "Select",
                                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    context: context,
                                    firstDate: DateTime.now().subtract(Duration(days: 1000)),
                                    lastDate: DateTime.now().add(Duration(days: 1000)),
                                  );
                                  if(selectedDate != null){
                                    setState(() {
                                      // _textEditingController.text = formatDate(selectedDate);
                                    });
                                    // widget.onDateSelection(_textEditingController.text);
                                  }
                                },
                                textCon: TextEditingController(),
                                suffixWidget: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    AppAssets.calenderIcon,
                                  ),
                                ),
                                hintText: "Select Date",
                                inputType: TextInputType.text,
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              addH(12),
              CustomButton(
                text: "Apply Filters",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectorWidget extends StatelessWidget {
  const SelectorWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.selectedItems,
  });

  final String title;
  final void Function()? onTap;
  final List<String> selectedItems;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          FieldTitle(title),
          const Spacer(),
          Row(
            children: [
              Text(
                selectedItems.isEmpty
                    ? "Select"
                    : "${selectedItems.length} selected",
                style: const TextStyle(
                  color: Color(0xff7C7C7C),
                  fontSize: 14,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
                color: Color(0xff7C7C7C),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
