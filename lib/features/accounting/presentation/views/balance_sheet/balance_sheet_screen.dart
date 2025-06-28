import 'package:amar_pos/core/core.dart';
import 'balance_sheet_controller.dart';
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

class BalanceSheetScreen extends StatefulWidget {
  static const routeName = '/accounting/balance-sheet-screen';

  const BalanceSheetScreen({super.key});

  @override
  State<BalanceSheetScreen> createState() => _BalanceSheetScreenState();
}

class _BalanceSheetScreenState extends State<BalanceSheetScreen>
    with SingleTickerProviderStateMixin {
  BalanceSheetController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Balance Sheet"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 1000)),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
                initialDate: controller.selectedDateTime.value,
              );
              controller.selectedDateTime.value = selectedDate;
              if (selectedDate != null) {
                controller.update(['date_status']);
                controller.getBalanceSheet();
              }
            },
            icon: SvgPicture.asset(AppAssets.calenderIcon),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20, bottom: 20),
          child: Column(
            children: [
              addH(12),
              GetBuilder<BalanceSheetController>(
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
                        'Date : ${controller.selectedDateTime.value != null ? formatDate(controller.selectedDateTime.value!) : formatDate(DateTime.now())}',
                        style: TextStyle(color: Color(0xff7C7C7C)),
                      ),
                      if(controller.selectedDateTime.value != null) ...[
                        addW(12),
                        GestureDetector(
                          onTap: () {
                            controller.selectedDateTime.value = null;
                            controller.update(['date_status']);
                            controller.getBalanceSheet();
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
                child: GetBuilder<BalanceSheetController>(
                  id: 'balance_sheet_list',
                  builder: (controller) {
                    if (controller.profitOrLossListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.balanceSheetListResponseModel == null ) {
                      return const Center(child: Text("Something went wrong"));
                    } else if (controller.balanceSheetList.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        // minWidth: 800,
                        empty: const Center(
                          child: Text("No Data Found"),
                        ),
                        headingRowColor: WidgetStatePropertyAll(AppColors.primary),
                        dividerThickness: .5,
                        headingRowHeight: 40,

                        headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.grey.shade200, // Color between rows
                            width: .5,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.grey,
                            width: .5,
                          ),
                        ),
                        columns: [
                          DataColumn2(
                            label: Center(
                                child: Text(
                              'Account Title',
                              textAlign: TextAlign.center,
                            )),
                            size: ColumnSize.L
                          ),
                          DataColumn2(
                              label: Center(
                                  child: Text(
                                'Amount',
                                textAlign: TextAlign.center,
                              )),
                            numeric: true,
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Center(
                                child: Text(
                              'Amount',
                              textAlign: TextAlign.center,
                            )),
                            size: ColumnSize.S,
                            numeric: true,
                          ),
                        ],
                        rows: [
                          ...controller.balanceSheetList.map((e) {
                            int index = controller.balanceSheetList.indexOf(e);

                            return DataRow(
                              color: index % 2 == 0
                                  ? const WidgetStatePropertyAll(Colors.white)
                                  : WidgetStatePropertyAll(
                                      Colors.yellow.withOpacity(.03)),
                              cells: [
                                DataCell(
                                  AutoSizeText(
                                    minFontSize: 2,
                                    maxFontSize: 10,
                                    maxLines:2,
                                    e.name??'N/A',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:  Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                // _buildDataCell(isNumber: false ,e.name??'N/A', maxLines: 2,),
                                _buildDataCell(Methods.getFormattedNumber(
                                e.debit?.toDouble() ?? 0,
                                ), maxLines: 2, isNumber: true),

                                _buildDataCell(Methods.getFormattedNumber(
                                  e.credit?.toDouble() ?? 0,
                                ), maxLines: 2,isNumber: true),
                              ],
                            );
                          })
                        ],
                      ),
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
