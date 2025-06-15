import 'dart:math';

import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/return/presentation/widgets/return_history_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/pager_list_view.dart';
import '../../../../core/widgets/reusable/forbidden_access_full_screen_widget.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';
import '../../data/models/return_history/return_history_response_model.dart';

class ReturnHistoryScreen extends StatefulWidget {
  ReturnHistoryScreen({super.key, required this.onChange});
  Function(int value) onChange;

  @override
  State<ReturnHistoryScreen> createState() => _ReturnHistoryScreenState();
}

class _ReturnHistoryScreenState extends State<ReturnHistoryScreen> {
  final ReturnController controller = Get.find();

  @override
  void initState() {
    if(controller.historyAccess) {
      controller.getReturnHistory();
    }
    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: !controller.historyAccess ? const ForbiddenAccessFullScreenWidget()  : Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    textCon: controller.searchProductController,
                    hintText: "Search...",
                    brdrClr: Colors.transparent,
                    txtSize: 12,
                    debounceDuration: const Duration(
                      milliseconds: 300,
                    ),
                    // noInputBorder: true,
                    brdrRadius: 40,
                    prefixWidget: Icon(Icons.search),
                    onChanged: (value){
                      controller.getReturnHistory();
                    },
                  ),
                ),
                addW(8),
                CustomSvgIconButton(
                  bgColor: const Color(0xffEBFFDF),
                  onTap: () {
                    controller.downloadList(isPdf: false, returnHistory: true);
                    // controller.downloadStockLedgerReport(
                    //     isPdf: false, context: context);
                  },
                  assetPath: AppAssets.excelIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadList(isPdf: true, returnHistory: true);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {
                    controller.downloadList(isPdf: true, returnHistory: true,shouldPrint: true);
                  },
                  assetPath: AppAssets.printIcon,
                )
              ],
            ),
            addH(8),
            GetBuilder<ReturnController>(
              id: 'total_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isReturnHistoryListLoading,
                    title: 'Invoice',
                    value: controller.returnHistoryResponseModel != null
                        ? Methods.getFormattedNumber(controller
                        .returnHistoryResponseModel!.countTotal
                        .toDouble())
                        : null,
                    asset: AppAssets.invoice,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isReturnHistoryListLoading,
                    title: 'Returned Amount',
                    value: controller.returnHistoryResponseModel != null
                        ? Methods.getFormatedPrice(controller
                        .returnHistoryResponseModel!.amountTotal
                        .toDouble())
                        : null,
                    asset: AppAssets.amount,
                  ),
                ],
              ),
            ),
            addH(8),
            Expanded(
              child: GetBuilder<ReturnController>(
                id: 'return_history_list',
                builder: (controller) {
                  if (controller.isReturnHistoryListLoading) {
                    return Center(
                      child: RandomLottieLoader.lottieLoader(),
                    );
                  }else if(controller.returnHistoryResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.returnHistoryList.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getReturnHistory();
                    },
                    child: PagerListView<ReturnHistory>(
                      // scrollController: _scrollController,
                      items: controller.returnHistoryList,
                      itemBuilder: (_, item) {
                        return ReturnHistoryItemWidget(returnHistory: item,onChange: (value) {
                          widget.onChange(value);
                        },);
                      },
                      isLoading: controller.isReturnHistoryLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getReturnHistory(page: nextPage);
                      },
                      totalPage: controller
                          .returnHistoryResponseModel?.data.meta?.lastPage ??
                          0,
                      totalSize:
                      controller.returnHistoryResponseModel?.data.meta?.total ??
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