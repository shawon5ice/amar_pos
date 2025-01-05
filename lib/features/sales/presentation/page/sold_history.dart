import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_history_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/pager_list_view.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';

class SoldHistory extends StatefulWidget {
  const SoldHistory({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      // showModalBottomSheet(
                      //   context: context,
                      //   builder: (context) =>
                      //       const StockLedgerFilterBottomSheet(),
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 12, bottom: 12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search),
                          addW(8),
                          const Text("Search"),
                          const Spacer(),
                        ],
                      ),
                    )),
              ),
              addW(8),
              CustomSvgIconButton(
                bgColor: const Color(0xffEBFFDF),
                onTap: () {
                  // controller.downloadStockLedgerReport(
                  //     isPdf: false, context: context);
                },
                assetPath: AppAssets.excelIcon,
              ),
              addW(4),
              CustomSvgIconButton(
                bgColor: const Color(0xffE1F2FF),
                onTap: () {
                  // controller.downloadStockLedgerReport(
                  //     isPdf: true, context: context);
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
          addH(16.px),
          Expanded(
            child: GetBuilder<SalesController>(
              id: 'sold_history_list',
              builder: (controller) {
                if (controller.isSaleHistoryListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    controller.getSoldHistory();
                  },
                  child: PagerListView<SaleHistory>(
                    items: controller.saleHistoryList,
                    itemBuilder: (_, item) {
                      return SoldHistoryItemWidget(saleHistory: item,);
                    },
                    isLoading: controller.isLoadingMore,
                    hasError: controller.hasError.value,
                    onNewLoad: (int nextPage) async {
                      await controller.getSoldHistory(page: nextPage);
                    },
                    totalPage: controller
                        .saleHistoryResponseModel?.data.meta.lastPage ??
                        0,
                    totalSize: controller
                        .saleHistoryResponseModel?.data.meta.total ??
                        0,
                    itemPerPage: 10,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
