import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_ledger/supplier_ledger_list_response_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/methods/helper_methods.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../widgets/client_ledger_item.dart';
import '../supplier_payment_controller.dart';

class SupplierLedgerStatementScreen extends StatefulWidget {
  static const String routeName = '/supplier-ledger-statement';

  const SupplierLedgerStatementScreen({
    super.key,
  });

  @override
  State<SupplierLedgerStatementScreen> createState() =>
      _ClientLedgerStatementScreenState();
}

class _ClientLedgerStatementScreenState
    extends State<SupplierLedgerStatementScreen> {
  SupplierPaymentController controller = Get.find();

  late SupplierLedgerData supplierLedgerData;
  int i = 1;

  @override
  void initState() {
    i = 1;
    supplierLedgerData = Get.arguments;
    controller.getSupplierLedgerStatement(id: supplierLedgerData.id);
    super.initState();
  }

  @override
  void dispose() {
    controller.supplierLedgerStatementResponseModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statement"),
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
                i = 1;
                controller.getSupplierLedgerStatement(id: supplierLedgerData.id);
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
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      textCon: controller.searchController,
                      hintText: "Search...",
                      brdrClr: Colors.transparent,
                      txtSize: 12,
                      debounceDuration: const Duration(
                        milliseconds: 500,
                      ),
                      // noInputBorder: true,
                      brdrRadius: 40,
                      prefixWidget: Icon(Icons.search),
                      onChanged: (value){
                        i = 1;
                        controller.getSupplierLedgerStatement(id: supplierLedgerData.id,);
                      },
                    ),
                  ),
                  addW(8),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffEBFFDF),
                    onTap: () {
                      controller.downloadStatement(isPdf: false, clientID: supplierLedgerData.id);
                    },
                    assetPath: AppAssets.excelIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffE1F2FF),
                    onTap: () {
                      controller.downloadStatement(isPdf: true, clientID: supplierLedgerData.id);
                    },
                    assetPath: AppAssets.downloadIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffFFFCF8),
                    onTap: () {
                      controller.downloadStatement(isPdf: true, clientID: supplierLedgerData.id, shouldPrint: true);
                    },
                    assetPath: AppAssets.printIcon,
                  )
                ],
              ),
              addH(8.px),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    StatementItemTitleValueWidget(
                      title: "Supplier ID",
                      value: supplierLedgerData.code ?? '--',
                      valueFontSize: 16,
                      valueFontWeight: FontWeight.w600,
                    ),
                    StatementItemTitleValueWidget(
                      title: "Supplier Name",
                      value: supplierLedgerData.name ?? '--',
                      valueFontSize: 16,
                      valueFontWeight: FontWeight.w600,
                    ),
                    StatementItemTitleValueWidget(
                      title: "Phone",
                      value: supplierLedgerData.phone ?? '--',
                      valueFontSize: 16,
                      valueFontWeight: FontWeight.w400,
                    ),
                    // StatementItemTitleValueWidget(
                    //   title: "Purpose",
                    //   value: supplierLedgerData..name,
                    // ),
                    StatementItemTitleValueWidget(
                      title: "Due Amount",
                      value: Methods.getFormatedPrice(supplierLedgerData.due.toDouble()),
                      valueColor: Color(0xffFF0000),
                    ),
                    StatementItemTitleValueWidget(
                      title: "Last Payment",
                      value: supplierLedgerData.lastPaymentDate ?? '--',
                    ),
                  ],
                ),
              ),
              Obx(() {
                return controller.selectedDateTimeRange.value == null ? addH(20): Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
                    addW(16),
                    IconButton(onPressed: (){
                      controller.selectedDateTimeRange.value = null;
                      controller.getSupplierLedgerStatement(id: supplierLedgerData.id);
                    }, icon: Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                  ],
                );
              }),
              Expanded(
                child: GetBuilder<SupplierPaymentController>(
                  id: 'supplier_ledger_statement',
                  builder: (controller) {
                    if (controller.isSupplierLedgerStatementListLoading) {
                      return RandomLottieLoader.lottieLoader();
                    } else if (controller.supplierLedgerStatementResponseModel ==
                        null) {
                      return Center(
                        child: Text(
                          "Something went wrong",
                          style: context.textTheme.titleLarge,
                        ),
                      );
                    }
                    final statement = controller.supplierLedgerStatementResponseModel!.data!.data;

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
                            fontWeight: FontWeight.bold, color: Colors.white,fontSize: 12),
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
                            label: _HeaderCell("SL"),
                            size: ColumnSize.S,
                            fixedWidth: 32,
                          ),
                          DataColumn2(
                            size: ColumnSize.M,
                            label: _HeaderCell("Date"),
                          ),
                          DataColumn2(
                              label: _HeaderCell("Invoice No."),
                              size: ColumnSize.M,
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: _HeaderCell("Debit"),
                            numeric: true,
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: _HeaderCell("Credit"),
                            numeric: true,
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: _HeaderCell("Balance"),
                            numeric: true,
                          ),
                        ],
                        rows: [
                          ...controller.supplierLedgerStatementResponseModel!.data!.data!.map((e) {
                            int index = controller.supplierLedgerStatementResponseModel!.data!.data!.indexOf(e);

                            return DataRow(
                              color: index % 2 == 0
                                  ? const WidgetStatePropertyAll(Colors.white)
                                  : WidgetStatePropertyAll(
                                  Colors.yellow.withOpacity(.03)),
                              cells: [
                                _buildDataCell((index+1).toString()),
                                _buildDataCell(e.date, maxLines: 3),
                                _buildDataCell(
                                    e.slNo,
                                    maxLines: 2),
                                _buildDataCell(
                                    Methods.getFormattedNumber(
                                      e.debit.toDouble() ?? 0,
                                    ),
                                    maxLines: 2),
                                _buildDataCell(
                                    Methods.getFormattedNumber(
                                      e.credit.toDouble() ?? 0,
                                    ),
                                    maxLines: 2),
                                _buildDataCell(
                                    Methods.getFormattedNumber(
                                      e.balance.toDouble() ?? 0,
                                    ),
                                    maxLines: 2),
                              ],
                            );
                          }),
                          DataRow(
                            color: WidgetStatePropertyAll(Color(0xffEFEFEF)),
                            cells: [
                              _buildDataCell(""),
                              _buildDataCell(""),
                              _buildDataCell("Total",isBold: true),
                              _buildDataCell(
                                  Methods.getFormattedNumber(
                                    controller.supplierLedgerStatementResponseModel!.data!.debit!.toDouble(),
                                  ),
                                  isBold: true,
                                  maxLines: 2),
                              _buildDataCell(
                                  Methods.getFormattedNumber(
                                    controller.supplierLedgerStatementResponseModel!.data!.credit!.toDouble(),
                                  ),
                                  isBold: true,
                                  maxLines: 2),
                              _buildDataCell(
                                  Methods.getFormattedNumber(
                                    controller.supplierLedgerStatementResponseModel!.data!.balance!.toDouble(),
                                  ),
                                  isBold: true,
                                  maxLines: 2),
                            ],
                          )
                        ],
                      ),
                    );
                    return Column(
                      children: [
                        // Fixed Header
                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: {
                            0: FixedColumnWidth(40.w),
                            1: FlexColumnWidth(80.w),
                            2: FlexColumnWidth(80.w),
                            3: FixedColumnWidth(60.w),
                            4: FixedColumnWidth(60.w),
                            5: FixedColumnWidth(60.w),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.grey[200]),
                              children: const [
                                _HeaderCell("SL."),
                                _HeaderCell("Date"),
                                _HeaderCell("Invoice No."),
                                _HeaderCell("Debit"),
                                _HeaderCell("Credit"),
                                _HeaderCell("Balance"),
                              ],
                            ),
                          ],
                        ),

                        // Scrollable Middle Rows
                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: {
                            0: FixedColumnWidth(40.w),
                            1: FlexColumnWidth(80.w),
                            2: FlexColumnWidth(80.w),
                            3: FixedColumnWidth(60.w),
                            4: FixedColumnWidth(60.w),
                            5: FixedColumnWidth(60.w),
                          },
                          children: List.generate(
                            controller.supplierLedgerStatementResponseModel!.data!.data!.length,
                                (index) {
                              final statement = controller.supplierLedgerStatementResponseModel!.data!.data![index];
                              return TableRow(
                                children: [
                                  _Cell("${index + 1}"),
                                  _Cell("${statement.date}",maxLine: 2,),
                                  _Cell("${statement.slNo}"),
                                  _Cell("${Methods.getFormattedNumber(statement.debit.toDouble())}"),
                                  _Cell("${Methods.getFormattedNumber(statement.credit.toDouble())}"),
                                  _Cell("${Methods.getFormattedNumber(statement.balance.toDouble())}"),
                                ],
                              );
                            },
                          ),
                        ),

                        // Fixed Footer
                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: {
                            0: FixedColumnWidth(40.w),
                            1: FlexColumnWidth(80.w),
                            2: FlexColumnWidth(80.w),
                            3: FixedColumnWidth(60.w),
                            4: FixedColumnWidth(60.w),
                            5: FixedColumnWidth(60.w),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.green[900]),
                              children: [
                                const SizedBox.shrink(),
                                const SizedBox.shrink(),
                                _FooterCell("Total"),
                                _FooterCell("${Methods.getFormattedNumber(controller.supplierLedgerStatementResponseModel!.data!.debit!.toDouble())}"),
                                _FooterCell("${Methods.getFormattedNumber(controller.supplierLedgerStatementResponseModel!.data!.credit!.toDouble())}"),
                                _FooterCell("${Methods.getFormattedNumber(controller.supplierLedgerStatementResponseModel!.data!.balance!.toDouble())}"),
                              ],
                            ),
                          ],
                        ),
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

  DataCell _buildDataCell(String data, {int maxLines = 1,bool? isBold}) {
    return DataCell(
      Center(
        child: AutoSizeText(
          minFontSize: 5,
          maxFontSize: 10,
          maxLines: maxLines,
          data,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isBold != null ? FontWeight.bold : FontWeight.normal
          ),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
        text,
        maxLines: 1,
        minFontSize: 2,
        maxFontSize: 12,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  int? maxLine;
  _Cell(this.text, {this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AutoSizeText(
        text,
        maxLines: maxLine?? 1,
        minFontSize: 2,
        maxFontSize: 10,
        textAlign: TextAlign.center,
      ),
    );
  }

}

class _FooterCell extends StatelessWidget {
  final String text;
  const _FooterCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AutoSizeText(
        text,
        maxLines: 1,
        minFontSize: 2,
        maxFontSize: 10,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
