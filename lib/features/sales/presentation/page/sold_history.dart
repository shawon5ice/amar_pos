import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_history_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/pager_list_view.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';

class SoldHistory extends StatefulWidget {
  SoldHistory({super.key,required this.onChange});

  Function(int value) onChange;

  @override
  State<SoldHistory> createState() => _SoldHistoryState();
}

class _SoldHistoryState extends State<SoldHistory> {
  final SalesController controller = Get.find();

  @override
  void initState() {
    controller.getSoldHistory();
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
        body: Column(
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
                      milliseconds: 500,
                    ),
                    // noInputBorder: true,
                    brdrRadius: 40,
                    prefixWidget: Icon(Icons.search),
                    onChanged: (value){
                      controller.getSoldHistory(page: 1);
                    },
                  ),
                ),
                addW(8),
                CustomSvgIconButton(
                  bgColor: const Color(0xffEBFFDF),
                  onTap: () {
                    controller.downloadList(isPdf: false, saleHistory: true);
                  },
                  assetPath: AppAssets.excelIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadList(isPdf: true, saleHistory: true);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {
                    controller.downloadList(isPdf: true, saleHistory: true,shouldPrint: true);
                  },
                  assetPath: AppAssets.printIcon,
                )
              ],
            ),
            addH(8),
            GetBuilder<SalesController>(
              id: 'total_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isSaleHistoryListLoading,
                    title: 'Invoice',
                    value: controller.saleHistoryResponseModel != null
                        ? Methods.getFormattedNumber(controller
                            .saleHistoryResponseModel!.countTotal
                            .toDouble())
                        : null,
                    asset: AppAssets.invoice,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isSaleHistoryListLoading,
                    title: 'Sold Amount',
                    value: controller.saleHistoryResponseModel != null
                        ? Methods.getFormatedPrice(controller
                            .saleHistoryResponseModel!.amountTotal
                            .toDouble())
                        : null,
                    asset: AppAssets.amount,
                  ),
                ],
              ),
            ),
            addH(8),
            Expanded(
              child: GetBuilder<SalesController>(
                id: 'sold_history_list',
                builder: (controller) {
                  if (controller.isSaleHistoryListLoading) {
                    return Center(
                      child: RandomLottieLoader.lottieLoader(),
                    );
                  }else if(controller.saleHistoryResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.saleHistoryResponseModel!.data.saleHistoryList.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getSoldHistory();
                    },
                    child: PagerListView<SaleHistory>(
                      // scrollController: _scrollController,
                      items: controller.saleHistoryList,
                      itemBuilder: (_, item) {
                        return SoldHistoryItemWidget(
                          saleHistory: item,
                          onChange: (value) {
                            widget.onChange(value);
                          },
                        );
                      },
                      isLoading: controller.isSaleHistoryLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getSoldHistory(page: nextPage);
                      },
                      totalPage: controller
                              .saleHistoryResponseModel?.data.meta.lastPage ??
                          0,
                      totalSize:
                          controller.saleHistoryResponseModel?.data.meta.total ??
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