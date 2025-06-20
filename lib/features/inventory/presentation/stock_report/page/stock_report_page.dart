import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../../../core/widgets/reusable/status/total_status_widget.dart';
import '../../../../../core/widgets/search_widget.dart';
import '../stock_report_controller.dart';
import '../widget/stock_report_item_widget.dart';

class StockReportPage extends StatefulWidget {
  const StockReportPage({super.key});

  @override
  State<StockReportPage> createState() => _StockReportPageState();
}

class _StockReportPageState extends State<StockReportPage> {
  final StockReportController controller = Get.find();

  @override
  void initState() {
    searchController = TextEditingController();
    controller.getStockReportList(page: 1, context: context);
    super.initState();
  }

  late TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                textCon: controller.searchEditingController,
                hintText: "Search...",
                brdrClr: Colors.transparent,
                txtSize: 12.sp,
                debounceDuration: const Duration(
                  milliseconds: 300,
                ),
                // noInputBorder: true,
                brdrRadius: 40.r,
                prefixWidget: Icon(Icons.search),
                onChanged: (value){
                  controller.getStockReportList(page: 1,);
                },
              ),
            ),
            addW(8),
            CustomSvgIconButton(
              bgColor: const Color(0xffEBFFDF),
              onTap: () {
                controller.downloadList(isPdf: false,search: controller.searchEditingController.text);
              },
              assetPath: AppAssets.excelIcon,
            ),
            addW(4),
            CustomSvgIconButton(
              bgColor: const Color(0xffE1F2FF),
              onTap: () {
                controller.downloadList(isPdf: true, search: controller.searchEditingController.text);
              },
              assetPath: AppAssets.downloadIcon,
            ),
            addW(4),
            CustomSvgIconButton(
              bgColor: const Color(0xffFFFCF8),
              onTap: () {
                controller.downloadList(isPdf: true, shouldPrint: true, search: controller.searchEditingController.text);
              },
              assetPath: AppAssets.printIcon,
            )
          ],
        ),
        addH(8),
        if(!controller.loginData!.businessOwner)
          ...[
            Text(controller.loginData!.store.name, style: context.textTheme.titleMedium,),
            addH(8),
          ],
        GetBuilder<StockReportController>(
          id: 'total_widget',
          builder: (controller) => Row(
            children: [
              TotalStatusWidget(
                flex: 3,
                isLoading: controller.isStockReportListLoading,
                title: 'Stock',
                value: controller.stockReportListResponseModel != null
                    ? Methods.getFormattedNumber(controller
                        .stockReportListResponseModel!.totalStock
                        .toDouble())
                    : null,
                asset: AppAssets.productBox,
              ),
              addW(12),
              TotalStatusWidget(
                flex: 4,
                isLoading: controller.isStockReportListLoading,
                title: 'Total Amount',
                value: controller.stockReportListResponseModel != null
                    ? Methods.getFormatedPrice(controller
                        .stockReportListResponseModel!.totalValue
                        .toDouble())
                    : null,
                asset: AppAssets.amount,
              ),
            ],
          ),
        ),
        addH(8),
        Expanded(
          child: GetBuilder<StockReportController>(
            id: 'stock_report_list',
            builder: (controller) {
              if (controller.isStockReportListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await controller.getStockReportList(page: 1,);
                },
                child: PagerListView(
                  items: controller.stockReportList,
                  itemBuilder: (_, item) {
                    return StockReportListItemWidget(stockReport: item);
                  },
                  isLoading: controller.isLoadingMore,
                  hasError: controller.hasError,
                  onNewLoad: (int nextPage) async {
                    await controller.getStockReportList(page: nextPage, );
                  },
                  totalPage: controller.stockReportListResponseModel
                          ?.stockReportResponse?.meta.lastPage ??
                      0,
                  totalSize: controller.stockReportListResponseModel
                          ?.stockReportResponse?.meta.total ??
                      0,
                  itemPerPage: 10,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
