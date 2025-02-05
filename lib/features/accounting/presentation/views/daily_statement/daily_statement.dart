import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/accounting/data/models/daily_statement/daily_statement_report_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/daily_statement/daily_statement_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';
import '../widgets/daily_statement_item.dart';
import 'status_widget.dart';

class DailyStatement extends StatefulWidget {
  const DailyStatement({super.key});

  @override
  State<DailyStatement> createState() => _DailyStatementState();
}

class _DailyStatementState extends State<DailyStatement> {

  DailyStatementController controller = Get.put(DailyStatementController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Statement"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldTitle("Select Account"),
                  addH(4),
                  Row(children: [
                    Expanded(child: CustomTextField(textCon: TextEditingController(), hintText: "Select Account")),
                    addW(8),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffEBFFDF),
                      onTap: () {
                        // controller.downloadList(isPdf: false, returnHistory: true);
                        // controller.downloadStockLedgerReport(
                        //     isPdf: false, context: context);
                      },
                      assetPath: AppAssets.excelIcon,
                    ),
                    addW(4),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffE1F2FF),
                      onTap: () {
                        // controller.downloadList(isPdf: true, returnHistory: true);
                      },
                      assetPath: AppAssets.downloadIcon,
                    ),
                    addW(4),
                    CustomSvgIconButton(
                      bgColor: const Color(0xffFFFCF8),
                      onTap: () {},
                      assetPath: AppAssets.printIcon,
                    )
                  ],),
                ],
              ),
            ),
            addH(8),
            GetBuilder<DailyStatementController>(
              id: 'total_statement_history',
              builder: (controller) {
                return Row(
                  children: [
                    StatusWidget(
                      title: 'In',
                      asset: AppAssets.cashIn,
                      value: Methods.getFormatedPrice(controller
                              .dailyStatementReportResponseModel
                              ?.data
                              .first
                              .credit ??
                          0),
                      loading: controller.isStatementListLoading,
                    ),
                    addW(8),
                    StatusWidget(
                      title: 'Out',
                      asset: AppAssets.cashOut,
                      value: Methods.getFormatedPrice(controller
                              .dailyStatementReportResponseModel
                              ?.data
                              .first
                              .debit ??
                          0),
                      loading: controller.isStatementListLoading,
                    ),
                    addW(8),
                    StatusWidget(
                      title: 'Balance',
                      asset: AppAssets.cash,
                      value: Methods.getFormatedPrice(controller
                              .dailyStatementReportResponseModel
                              ?.data
                              .first
                              .balance ??
                          0),
                      loading: controller.isStatementListLoading,
                    )
                  ],
                );
              },
            ),
            addH(8),
            Expanded(
              child: GetBuilder<DailyStatementController>(
                id: 'daily_statement_list',
                builder: (controller) {
                  if (controller.isStatementListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.dailyStatementReportResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.dailyStatementReportResponseModel!.data.first.data.data.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getDailyStatement(search: '', page: 1);
                    },
                    child: PagerListView<TransactionData>(
                      // scrollController: _scrollController,
                      items: controller.dailyStatementList,
                      itemBuilder: (_, item) {
                        return DailyStatementItem(transactionData: item,);
                      },
                      isLoading: controller.isLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getDailyStatement(page: nextPage);
                      },
                      totalPage: controller
                          .dailyStatementReportResponseModel?.data.first.data.lastPage ??
                          0,
                      totalSize:
                      controller
                          .dailyStatementReportResponseModel?.data.first.data.total ??
                          0,
                      itemPerPage: 10,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
