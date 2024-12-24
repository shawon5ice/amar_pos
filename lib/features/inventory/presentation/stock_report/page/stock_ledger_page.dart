import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/product_dd/products_dd_controller.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/widget/stock_ledger_filter_widgert.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/widget/stock_ledger_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../stock_report_controller.dart';
import '../widget/custom_svg_icon_widget.dart';
import '../widget/field_title_value_widget.dart';

class StockLedgerPage extends StatefulWidget {
  const StockLedgerPage({super.key});

  @override
  State<StockLedgerPage> createState() => _StockReportPageState();
}

class _StockReportPageState extends State<StockLedgerPage> {
  final StockReportController controller = Get.find();

  @override
  void initState() {
    controller.clearFilters();

    Get.put(OutletDDController());
    Get.put(ProductsDDController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<OutletDDController>();
    Get.delete<ProductsDDController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          const StockLedgerFilterBottomSheet(),
                    );
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
                        const Text("Filter Product "),
                        const Spacer(),
                        SvgPicture.asset(
                          AppAssets.filterIcon,
                          height: 20,
                          width: 20,
                        )
                      ],
                    ),
                  )),
            ),
            addW(8),
            CustomSvgIconButton(
              bgColor: const Color(0xffEBFFDF),
              onTap: () {},
              assetPath: AppAssets.excelIcon,
            ),
            addW(4),
            CustomSvgIconButton(
              bgColor: const Color(0xffE1F2FF),
              onTap: () {},
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
          child: GetBuilder<StockReportController>(
            id: 'stock_ledger_list',
            builder: (controller) {
              if (controller.isStockLedgerListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  controller.getStockLedgerList(page: 1);
                },
                child: controller.stockLedgerList.isEmpty
                    ? const Center(
                        child: Text(
                          "Please set filter to see stock ledger",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              children: [
                                FieldTitleValueWidget(
                                  title: "Product Name",
                                  value:
                                      controller.selectedProduct.value!.name,
                                ),
                                addH(4),
                                FieldTitleValueWidget(
                                  title: "Date",
                                  value:
                                      "${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}",
                                ),
                                addH(4),
                                FieldTitleValueWidget(
                                  title: "Outlet",
                                  value: controller.selectedOutlet.value!.name
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: PagerListView(
                              items: controller.stockLedgerList,
                              itemBuilder: (_, item) {
                                return StockLedgerListItem(item: item);
                              },
                              isLoading: controller.isLoadingMore,
                              hasError: controller.hasError,
                              onNewLoad: (int nextPage) async {
                                await controller.getStockLedgerList(
                                    page: nextPage);
                              },
                              totalPage: controller.stockLedgerListResponseModel
                                      ?.data.pagination.lastPage ??
                                  0,
                              totalSize: controller.stockLedgerListResponseModel
                                      ?.data.pagination.total ??
                                  0,
                              itemPerPage: 10,
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        )
      ],
    );
  }
}
