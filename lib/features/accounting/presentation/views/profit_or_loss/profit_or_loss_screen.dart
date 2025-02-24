import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'profit_or_loss_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';

class ProfitOrLossScreen extends StatefulWidget {
  static const routeName = '/accounting/profit-or-loss-screen';

  const ProfitOrLossScreen({super.key});

  @override
  State<ProfitOrLossScreen> createState() => _ProfitOrLossScreenState();
}

class _ProfitOrLossScreenState extends State<ProfitOrLossScreen>
    with SingleTickerProviderStateMixin {
  ProfitOrLossController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profit Or Loss"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              DateTimeRange? selectedDate = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 1000)),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
                initialDateRange: controller.selectedDateTimeRange.value,
              );
              controller.selectedDateTimeRange.value = selectedDate;
              if (selectedDate != null) {
                controller.update(['date_status']);
                controller.getBookLedger();
              }
            },
            icon: SvgPicture.asset(AppAssets.calenderIcon),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              addH(12),
              GetBuilder<ProfitOrLossController>(
                id: 'date_status',
                builder: (controller) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Date : ${controller.selectedDateTimeRange.value != null ? formatDate(controller.selectedDateTimeRange.value!.start) + ' - ' + formatDate(controller.selectedDateTimeRange.value!.end) : formatDate(DateTime.now())}',
                        style: TextStyle(color: Color(0xff7C7C7C)),
                      ),
                      if(controller.selectedDateTimeRange.value != null) ...[
                        addW(12),
                        GestureDetector(
                          onTap: () {
                            controller.selectedDateTimeRange.value = null;
                            controller.update(['date_status']);
                            controller.getBookLedger();
                          },
                          child: Icon(Icons.close, color: AppColors.error, size: 16,),
                        ),
                      ],
                      Spacer(),
                      addW(8),
                      CustomSvgIconButton(
                        bgColor: const Color(0xffEBFFDF),
                        onTap: () {
                          controller.downloadList(
                            isPdf: false,);
                        },
                        assetPath: AppAssets.excelIcon,
                      ),
                      addW(4),
                      CustomSvgIconButton(
                        bgColor: const Color(0xffE1F2FF),
                        onTap: () {
                          controller.downloadList(
                              isPdf: true,
                          );
                        },
                        assetPath: AppAssets.downloadIcon,
                      ),
                      addW(4),
                      CustomSvgIconButton(
                        bgColor: const Color(0xffFFFCF8),
                        onTap: () {
                          controller.downloadList(
                              isPdf: true, shouldPrint: true);
                        },
                        assetPath: AppAssets.printIcon,
                      )
                    ],
                  ),
                ),
              ),
              addH(12),
              Expanded(
                child: GetBuilder<ProfitOrLossController>(
                  id: 'profit_or_loss_list',
                  builder: (controller) {
                    if (controller.profitOrLossListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.profitOrLossListResponseModel == null ) {
                      return const Center(child: Text("Something went wrong"));
                    } else if (controller.profitOrLossList.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }
                    return DataTable2(
                      fixedColumnsColor: const Color(0xffEFEFEF),
                      // sortColumnIndex: 1,
                      // fixedLeftColumns: 1,
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 800,
                      empty: const Center(
                        child: Text("No Data Found"),
                      ),
                      headingRowColor:
                          const WidgetStatePropertyAll(Color(0xffEFEFEF)),
                      dividerThickness: .5,
                      headingRowHeight: 40,
                      headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      border: TableBorder.all(color: Colors.black, width: .5),
                      columns: [
                        DataColumn2(
                          label: Center(
                              child: Text(
                            'Account Title',
                            textAlign: TextAlign.center,
                          )),
                          fixedWidth: context.width/2.5,
                        ),
                        DataColumn2(
                            label: Center(
                                child: Text(
                              'Debit',
                              textAlign: TextAlign.center,
                            )),
                          numeric: true,
                          fixedWidth: 100,
                        ),
                        DataColumn2(
                          label: Center(
                              child: Text(
                            'Credit',
                            textAlign: TextAlign.center,
                          )),
                          fixedWidth: 100,
                          numeric: true,
                        ),
                      ],
                      rows: [
                        ...controller.profitOrLossList.map((e) {
                          int index = controller.profitOrLossList.indexOf(e);

                          return DataRow(
                            color: index % 2 == 0
                                ? const WidgetStatePropertyAll(Colors.white)
                                : WidgetStatePropertyAll(
                                    Colors.yellow.withOpacity(.03)),
                            cells: [
                              _buildDataCell(isNumber: false ,e.name??'N/A', maxLines: 2, alignLeft: e.align?.toLowerCase() == "left", alignRight: e.align?.toLowerCase() == "right", isMinus: e.isMinus == 1),
                              _buildDataCell(Methods.getFormattedNumber(
                              e.debit?.toDouble() ?? 0,
                              ), maxLines: 2, isMinus: e.isMinus == 1, isNumber: true),

                              _buildDataCell(Methods.getFormattedNumber(
                                e.credit?.toDouble() ?? 0,
                              ), maxLines: 2, isMinus: e.isMinus == 1,isNumber: true),
                            ],
                          );
                        })
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataCell _buildDataCell(String data, {int maxLines = 1, bool? alignLeft, bool? isMinus, bool? alignRight,required bool isNumber}) {

    return isNumber && data == "0" ?  DataCell(SizedBox.shrink()) :  DataCell(
        Align(
        alignment: alignLeft == true ? Alignment.centerLeft : alignRight == true?  Alignment.centerRight : Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(isMinus != null && isMinus == true && isNumber == false)AutoSizeText(
              minFontSize: 5,
              maxFontSize: 10,
              maxLines: maxLines,
              "(-) ",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.error,
              ),
            ),
            AutoSizeText(
              minFontSize: 5,
              maxFontSize: 10,
              maxLines: maxLines,
              data,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isMinus == true && isNumber ? AppColors.error : alignLeft == true? Color(0xff7C7C7C) : Colors.black,
                fontWeight: alignRight == true || isNumber ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      )
    );
  }
}
