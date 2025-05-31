import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dropdown_widget.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'trial_balance_controller.dart';
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

class TrialBalanceScreen extends StatefulWidget {
  static const routeName = '/accounting/trial-balance-screen';

  const TrialBalanceScreen({super.key});

  @override
  State<TrialBalanceScreen> createState() => _TrialBalanceScreenState();
}

class _TrialBalanceScreenState extends State<TrialBalanceScreen>
    with SingleTickerProviderStateMixin {
  TrialBalanceController controller = Get.find();

  ChartOfAccountPaymentMethod? selectedAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trial Balance"),
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
                controller.getBookLedger();
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
              GetBuilder<TrialBalanceController>(
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
              GetBuilder<TrialBalanceController>(
                id: 'total_widget',
                builder: (controller) => Row(
                  children: [
                    TotalStatusWidget(
                      flex: 3,
                        isLoading: controller.trialBalanceListLoading,
                      title: 'Debit',
                      value: controller.trialBalanceListResponseModel != null && controller
                          .trialBalanceListResponseModel!.data != null
                          ? Methods.getFormattedNumber(controller
                              .trialBalanceListResponseModel!.data!.first.debit!
                              .toDouble())
                          : null,
                    ),
                    addW(12),
                    TotalStatusWidget(
                      flex: 3,
                      isLoading: controller.trialBalanceListLoading,
                      title: 'Credit',
                      value: controller.trialBalanceListResponseModel != null && controller
                          .trialBalanceListResponseModel!.data != null
                          ? Methods.getFormattedNumber(controller
                              .trialBalanceListResponseModel!.data!.first.credit!
                              .toDouble())
                          : null,
                    ),
                  ],
                ),
              ),
              addH(12),
              Expanded(
                child: GetBuilder<TrialBalanceController>(
                  id: 'trial_balance_list',
                  builder: (controller) {
                    if (controller.trialBalanceListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.trialBalanceListResponseModel == null &&
                        selectedAccount != null) {
                      return const Center(child: Text("Something went wrong"));
                    } else if (controller.trialBalanceList.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                      child: DataTable2(
                        fixedColumnsColor: const Color(0xffEFEFEF),
                        // sortColumnIndex: 1,
                        fixedLeftColumns: 1,
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
                        columns: const [
                          DataColumn2(
                            label: Center(
                                child: Text(
                              'SL',
                              textAlign: TextAlign.center,
                            )),
                            size: ColumnSize.S,
                            fixedWidth: 40,
                          ),
                          DataColumn2(
                            size: ColumnSize.L,
                            label: Center(
                                child: Text(
                              'Account Title',
                              textAlign: TextAlign.center,
                            )),
                          ),
                          DataColumn2(
                              label: Center(
                                  child: Text(
                                'Debit',
                                textAlign: TextAlign.center,
                              )),
                            size: ColumnSize.S
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: Center(
                                child: Text(
                              'Credit',
                              textAlign: TextAlign.center,
                            )),
                            numeric: true,
                          ),
                        ],
                        rows: [
                          ...controller.trialBalanceList.map((e) {
                            int index = controller.trialBalanceList.indexOf(e);
                      
                            return DataRow(
                              color: index % 2 == 0
                                  ? const WidgetStatePropertyAll(Colors.white)
                                  : WidgetStatePropertyAll(
                                      Colors.yellow.withOpacity(.03)),
                              cells: [
                                _buildDataCell((index+1).toString()),
                                _buildDataCell(e.name??'N/A', maxLines: 3),
                                _buildDataCell(
                                    Methods.getFormattedNumber(
                                      e.debit?.toDouble() ?? 0,
                                    ),
                                    maxLines: 2),
                                _buildDataCell(
                                    Methods.getFormattedNumber(
                                      e.credit?.toDouble() ?? 0,
                                    ),
                                    maxLines: 2),
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

  DataCell _buildDataCell(String data, {int maxLines = 1}) {
    return DataCell(
      Center(
        child: AutoSizeText(
          minFontSize: 5,
          maxFontSize: 10,
          maxLines: maxLines,
          data,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
