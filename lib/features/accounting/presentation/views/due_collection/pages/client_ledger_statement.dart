import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../widgets/client_ledger_item.dart';
import '../../widgets/statement_data_source.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statement"),
        centerTitle: true,
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
                        controller.getClientLedgerStatement(id: clientLedgerData.id,);
                      },
                    ),
                  ),
                  addW(8),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffEBFFDF),
                    onTap: () {
                      // controller.downloadList(isPdf: false, purchaseHistory: true);
                      // controller.downloadStockLedgerReport(
                      //     isPdf: false, context: context);
                    },
                    assetPath: AppAssets.excelIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffE1F2FF),
                    onTap: () {
                      // controller.downloadList(isPdf: true, purchaseHistory: true);
                    },
                    assetPath: AppAssets.downloadIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffFFFCF8),
                    onTap: () {},
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
                      title: "Client Name",
                      value: clientLedgerData.name,
                      valueFontSize: 16,
                      valueFontWeight: FontWeight.w600,
                    ),
                    // StatementItemTitleValueWidget(
                    //   title: "Purpose",
                    //   value: clientLedgerData..name,
                    // ),
                    StatementItemTitleValueWidget(
                      title: "Due Amount",
                      value: Methods.getFormatedPrice(clientLedgerData.due.toDouble()),
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
                    return Table(
                      border: TableBorder.all(
                        color: Colors.grey,
                      ),
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
                            Padding(

                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                  "SL.",
                                  maxLines: 1,
                                  minFontSize: 2,
                                  maxFontSize: 12,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                  "Date",
                                  maxLines: 1,
                                  minFontSize: 2,
                                  maxFontSize: 12,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                  "Invoice No.",
                                  maxLines: 1,
                                  minFontSize: 2,
                                  maxFontSize: 12,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                  "Debit",
                                  maxLines: 1,
                                  minFontSize: 2,
                                  maxFontSize: 12,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                  "Credit",
                                  maxLines: 1,
                                  minFontSize: 2,
                                  maxFontSize: 12,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                  "Balance",
                                  maxLines: 1,
                                  minFontSize: 2,
                                  maxFontSize: 12,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        ...controller
                            .clientLedgerStatementResponseModel!.data!.data!
                            .map((statement) {
                          return TableRow(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: AutoSizeText("${i++}",
                                      maxLines: 1,
                                      minFontSize: 2,
                                      maxFontSize: 10,
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center)),
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: AutoSizeText("${statement.date}",
                                      maxLines: 1,
                                      minFontSize: 2,
                                      maxFontSize: 10,
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center)),
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: AutoSizeText("${statement.slNo}",
                                      maxLines: 1,
                                      minFontSize: 2,
                                      maxFontSize: 10,
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center)),
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: AutoSizeText(
                                      "${Methods.getFormattedNumber(statement.debit.toDouble())}",
                                      maxLines: 1,
                                      minFontSize: 2,
                                      maxFontSize: 10,
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center)),
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: AutoSizeText(
                                      "${Methods.getFormattedNumber(statement.credit.toDouble())}",
                                      maxLines: 1,
                                      minFontSize: 2,
                                      maxFontSize: 10,
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center)),
                              Padding(
                                  padding: EdgeInsets.all(8),
                                  child: AutoSizeText(
                                      "${Methods.getFormattedNumber(statement.balance.toDouble())}",
                                      minFontSize: 2,
                                      maxFontSize: 10,
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                      textAlign: TextAlign.center)),
                            ],
                          );
                        }),
                        TableRow(
                          decoration: BoxDecoration(color: Colors.green[900]),
                          children: [
                            SizedBox.shrink(),
                            SizedBox.shrink(),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText("Total",
                                    maxLines: 1,
                                    maxFontSize: 10,
                                    minFontSize: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                    "${Methods.getFormattedNumber(controller.clientLedgerStatementResponseModel!.data!.debit!.toDouble())}",
                                    minFontSize: 2,
                                    maxFontSize: 10,
                                    overflow: TextOverflow.visible,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                    "${Methods.getFormattedNumber(controller.clientLedgerStatementResponseModel!.data!.credit!.toDouble())}",
                                    maxLines: 1,
                                    minFontSize: 2,
                                    maxFontSize: 10,
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            Padding(
                                padding: EdgeInsets.all(8),
                                child: AutoSizeText(
                                    "${Methods.getFormattedNumber(controller.clientLedgerStatementResponseModel!.data!.balance!.toDouble())}",
                                    maxLines: 1,
                                    minFontSize: 2,
                                    maxFontSize: 10,
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
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
}
