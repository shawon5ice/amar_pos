import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/pager_list_view.dart';
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
    controller.getStockReportList(page: 1, context: context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidget(
          onChanged: (value) {
            // _brandController.searchBrand(search: value);
          },
        ),
        addH(16),
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
                  controller.getStockReportList(page: 1);
                },
                child: PagerListView(
                  items: controller.stockReportList,
                  itemBuilder: (_, item) {
                    return StockReportListItemWidget(stockReport: item);
                  },
                  isLoading: controller.isLoadingMore,
                  hasError: controller.hasError,
                  onNewLoad: (int nextPage) async {
                    await controller.getStockReportList(page: nextPage);
                  },
                  totalPage: controller
                      .stockReportListResponseModel?.stockReportResponse.meta.lastPage ??
                      0,
                  totalSize: controller
                      .stockReportListResponseModel?.stockReportResponse.meta.total ??
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
