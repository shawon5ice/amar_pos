import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dropdown_widget.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/ledger/ledger_controller.dart';
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

class LedgerScreen extends StatefulWidget {
  static const routeName = '/accounting/ledger-screen';

  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen>
    with SingleTickerProviderStateMixin {
  LedgerController controller = Get.find();

  ChartOfAccountPaymentMethod? selectedAccount;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ledger"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              DateTimeRange? selectedDate = await showDateRangePicker(
                context: context,
                firstDate:
                    DateTime.now().subtract(const Duration(days: 1000)),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
                initialDateRange: controller.selectedDateTimeRange.value,
              );
              controller.selectedDateTimeRange.value = selectedDate;
              if(selectedAccount != null){
                controller.getBookLedger(caID: selectedAccount!.id);
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CAPaymentMethodsDropDownWidget(
                              initialCAPaymentMethod: selectedAccount,
                              lastLevelAccount: true,
                              noTitle: true,
                              height: 48,
                              hint: "Select Account",
                              searchHint: "Search an account",
                              onCAPaymentMethodSelection: (value) {
                                selectedAccount = value;
                                controller.getBookLedger(
                                    caID: selectedAccount!.id);
                                controller.update(['selection_status']);
                              }),
                        ),
                        addW(8),
                        CustomSvgIconButton(
                          bgColor: const Color(0xffEBFFDF),
                          onTap: () {
                            controller.downloadList(
                                ca: selectedAccount,
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
                              ca: selectedAccount
                            );
                          },
                          assetPath: AppAssets.downloadIcon,
                        ),
                        addW(4),
                        CustomSvgIconButton(
                          bgColor: const Color(0xffFFFCF8),
                          onTap: () {
                            controller.downloadList(
                                ca: selectedAccount,
                                isPdf: true, shouldPrint: true);
                          },
                          assetPath: AppAssets.printIcon,
                        )
                      ],
                    ),
                    addH(8),
                    GetBuilder<LedgerController>(
                        id: 'selection_status',
                        builder: (controller) {
                          return selectedAccount != null
                              ? Align(alignment: Alignment.center,child: Text(selectedAccount!.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),))
                              : const SizedBox.shrink();
                          // Text("Book Ledger report for ${selectedAccount!.name}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),maxLines: 2,): SizedBox.shrink();
                        }),
                    addH(4),
                    Obx(() {
                      return controller.selectedDateTimeRange.value == null
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}",
                                  style: const TextStyle(
                                      fontSize: 14, color: AppColors.error),
                                ),
                                addW(16),
                                GestureDetector(
                                    onTap: () {
                                      controller.selectedDateTimeRange.value =
                                          null;
                                      if(selectedAccount != null){
                                        controller.getBookLedger(caID: selectedAccount!.id);
                                      }
                                    },
                                    child: const Icon(
                                      Icons.cancel_outlined,
                                      color: AppColors.error,
                                      size: 16,
                                    ))
                              ],
                            );
                    }),
                  ],
                ),
              ),
              addH(8),
              GetBuilder<LedgerController>(
                id: 'total_widget',
                builder: (controller) => Row(
                  children: [
                    TotalStatusWidget(
                      flex: 3,
                      isLoading: controller.ledgerListLoading,
                      title: 'Debit',
                      value: controller.bookLedgerListResponseModel != null
                          ? Methods.getFormattedNumber(controller
                          .bookLedgerListResponseModel!.data!.first.debit!
                          .toDouble())
                          : null,
                    ),
                    addW(12),
                    TotalStatusWidget(
                      flex: 3,
                      isLoading: controller.ledgerListLoading,
                      title: 'Credit',
                      value: controller.bookLedgerListResponseModel != null
                          ? Methods.getFormattedNumber(controller
                          .bookLedgerListResponseModel!.data!.first.credit!
                          .toDouble())
                          : null,
                    ),
                    addW(12),
                    TotalStatusWidget(
                      flex: 3,
                      isLoading: controller.ledgerListLoading,
                      title: 'Balance',
                      value: controller.bookLedgerListResponseModel != null
                          ? Methods.getFormattedNumber(controller
                          .bookLedgerListResponseModel!.data!.first.balance!
                          .toDouble())
                          : null,
                    ),
                  ],
                ),
              ),
              addH(12),
              Expanded(
                child: GetBuilder<LedgerController>(
                  id: 'ledger_list',
                  builder: (controller) {
                    if (selectedAccount == null) {
                      return const Center(
                          child: Text("Please select an account first"));
                    }
                    if (controller.ledgerListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.bookLedgerListResponseModel == null &&
                        selectedAccount != null) {
                      return const Center(child: Text("Something went wrong"));
                    } else if (controller.ledgerList.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                      child: DataTable2(
                        fixedColumnsColor: const Color(0xffEFEFEF),
                        sortColumnIndex: 1,
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
                        minWidth: context.width * 1.2,
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
                            label: Center(child: Text('Date', textAlign: TextAlign.center)),
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Center(child: Text('ID', textAlign: TextAlign.center)),
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Center(child: Text('Particular', textAlign: TextAlign.center)),
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Center(child: Text('Debit', textAlign: TextAlign.center)),
                            numeric: true,
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Center(child: Text('Credit', textAlign: TextAlign.center)),
                            numeric: true,
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Center(child: Text('Balance', textAlign: TextAlign.center)),
                            numeric: true,
                            size: ColumnSize.L,
                          ),
                        ],
                        rows: [
                          ...controller.ledgerList.map((e) {
                            final index = controller.ledgerList.indexOf(e);
                            return DataRow(
                              color: WidgetStatePropertyAll(
                                index % 2 == 0 ? Colors.white : Colors.yellow.withOpacity(.03),
                              ),
                              cells: [
                                _buildDataCell(e.date, maxLines: 2),
                                _buildDataCell(e.slNo, maxLines: 2),
                                _buildDataCell(e.accountName ?? 'N/A', maxLines: 2),
                                _buildDataCell(_format(e.debit), maxLines: 2),
                                _buildDataCell(_format(e.credit), maxLines: 2),
                                _buildDataCell(_format(e.balance), maxLines: 2),
                              ],
                            );
                          }).toList(),
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
  String _format(num? value) => Methods.getFormattedNumber(value!.toDouble());

  DataCell _buildDataCell(String data,{int maxLines = 1}) {
    return DataCell(
      Center(
        child: AutoSizeText(
          minFontSize: 2,
          maxFontSize: 10,
          maxLines: maxLines,
          data,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
