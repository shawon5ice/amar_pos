import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
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

class ClientLedgerStatementScreen extends StatefulWidget {
  static const String routeName = '/client-ledger-statement';

  const ClientLedgerStatementScreen({
    super.key,
  });

  @override
  State<ClientLedgerStatementScreen> createState() =>
      _ClientLedgerStatementScreenState();
}

class _ClientLedgerStatementScreenState
    extends State<ClientLedgerStatementScreen> {
  DueCollectionController controller = Get.find();

  late ClientLedgerData clientLedgerData;
  int i = 1;

  @override
  void initState() {
    i = 1;
    clientLedgerData = Get.arguments;
    controller.getClientLedgerStatement(id: clientLedgerData.id);
    super.initState();
  }

  @override
  void dispose() {
    controller.clientLedgerStatementResponseModel = null;
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
                controller.getClientLedgerStatement(id: clientLedgerData.id);
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
                      onChanged: (value) {
                        i = 1;
                        controller.getClientLedgerStatement(
                          id: clientLedgerData.id,
                        );
                      },
                    ),
                  ),
                  addW(8),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffEBFFDF),
                    onTap: () {
                      controller.downloadStatement(
                          isPdf: false, clientID: clientLedgerData.id);
                    },
                    assetPath: AppAssets.excelIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffE1F2FF),
                    onTap: () {
                      controller.downloadStatement(
                          isPdf: true, clientID: clientLedgerData.id);
                    },
                    assetPath: AppAssets.downloadIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffFFFCF8),
                    onTap: () {
                      controller.downloadStatement(
                          isPdf: false,
                          clientID: clientLedgerData.id,
                          shouldPrint: true);
                    },
                    assetPath: AppAssets.printIcon,
                  )
                ],
              ),
              addH(8),
              Obx(() {
                return controller.selectedDateTimeRange.value == null
                    ? addH(0)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}",
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.error),
                          ),
                          addW(16),
                          IconButton(
                              onPressed: () {
                                controller.selectedDateTimeRange.value = null;
                                controller.getClientLedgerStatement(
                                    id: clientLedgerData.id);
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                size: 18,
                                color: AppColors.error,
                              ))
                        ],
                      );
              }),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    StatementItemTitleValueWidget(
                      title: "Client ID",
                      value: clientLedgerData.clientNo,
                      valueFontSize: 16,
                      valueFontWeight: FontWeight.w600,
                    ),
                    StatementItemTitleValueWidget(
                      title: "Client Name",
                      value: clientLedgerData.name,
                      valueFontSize: 16,
                      valueFontWeight: FontWeight.w600,
                    ),
                    StatementItemTitleValueWidget(
                      title: "Phone",
                      value: clientLedgerData.phone,
                      valueFontSize: 16,
                      valueFontWeight: FontWeight.w600,
                    ),
                    // StatementItemTitleValueWidget(
                    //   title: "Purpose",
                    //   value: clientLedgerData..name,
                    // ),
                    StatementItemTitleValueWidget(
                      title: "Due Amount",
                      value: Methods.getFormatedPrice(
                          clientLedgerData.due.toDouble()),
                      valueColor: Color(0xffFF0000),
                    ),
                    StatementItemTitleValueWidget(
                      title: "Last Payment",
                      value: clientLedgerData.lastPaymentDate ?? '--',
                    ),
                  ],
                ),
              ),
              addH(12),
              Expanded(
                child: GetBuilder<DueCollectionController>(
                  id: 'client_ledger_statement',
                  builder: (controller) {
                    if (controller.isClientLedgerStatementListLoading) {
                      return RandomLottieLoader.lottieLoader();
                    } else if (controller.clientLedgerStatementResponseModel ==
                        null) {
                      return Center(
                        child: Text(
                          "Something went wrong",
                          style: context.textTheme.titleLarge,
                        ),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
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
                        headingRowColor:
                            WidgetStatePropertyAll(AppColors.primary),
                        dividerThickness: .5,
                        headingRowHeight: 40,

                        headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12),
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
                          ...controller
                              .clientLedgerStatementResponseModel!.data!.data!
                              .map((e) {
                            int index = controller
                                .clientLedgerStatementResponseModel!.data!.data!
                                .indexOf(e);

                            return DataRow(
                              color: index % 2 == 0
                                  ? const WidgetStatePropertyAll(Colors.white)
                                  : WidgetStatePropertyAll(
                                      Colors.yellow.withOpacity(.03)),
                              cells: [
                                _buildDataCell((index + 1).toString()),
                                _buildDataCell(e.date, maxLines: 3),
                                _buildDataCell(e.slNo, maxLines: 2),
                                _buildDataCell(
                                  Methods.getFormattedNumber(
                                    e.debit.toDouble() ?? 0,
                                  ),
                                ),
                                _buildDataCell(
                                  Methods.getFormattedNumber(
                                    e.credit.toDouble() ?? 0,
                                  ),
                                ),
                                _buildDataCell(
                                  Methods.getFormattedNumber(
                                    e.balance.toDouble() ?? 0,
                                  ),
                                ),
                              ],
                            );
                          }),
                          DataRow(
                            color: WidgetStatePropertyAll(Color(0xffEFEFEF)),
                            cells: [
                              _buildDataCell(""),
                              _buildDataCell(""),
                              _buildDataCell("Total", isBold: true),
                              _buildDataCell(
                                Methods.getFormattedNumber(controller
                                    .clientLedgerStatementResponseModel!
                                    .data!
                                    .debit!
                                    .toDouble()),
                                isBold: true,
                              ),
                              _buildDataCell(
                                Methods.getFormattedNumber(controller
                                    .clientLedgerStatementResponseModel!
                                    .data!
                                    .credit!
                                    .toDouble()),
                                isBold: true,
                              ),
                              _buildDataCell(
                                Methods.getFormattedNumber(controller
                                    .clientLedgerStatementResponseModel!
                                    .data!
                                    .balance!
                                    .toDouble()),
                                isBold: true,
                              ),
                            ],
                          )
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

  DataCell _buildDataCell(String data, {int maxLines = 1, bool? isBold}) {
    return DataCell(
      Center(
        child: AutoSizeText(
          minFontSize: 5,
          maxFontSize: 10,
          maxLines: maxLines,
          data,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: isBold != null ? FontWeight.bold : FontWeight.normal),
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
