import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/widget/stock_ledger_filter_widgert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../../../../../core/widgets/search_widget.dart';
import '../stock_report_controller.dart';
import '../widget/stock_report_item_widget.dart';

class StockLedgerPage extends StatefulWidget {
  const StockLedgerPage({super.key});

  @override
  State<StockLedgerPage> createState() => _StockReportPageState();
}

class _StockReportPageState extends State<StockLedgerPage> {
  final StockReportController controller = Get.find();

  @override
  void initState() {
    Get.put(OutletDDController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<OutletDDController>();
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
                      builder: (context) => const StockLedgerFilterBottomSheet(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 12,bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Filter Product "),
                        Spacer(),
                        SvgPicture.asset(AppAssets.filterIcon, height: 20, width: 20,)
                      ],
                    ),
                  )),
            ),
            addW(8),
            CustomSvgIconButton(
              bgColor: Color(0xffEBFFDF),
              onTap: (){},
              assetPath: AppAssets.excelIcon,
            ),
            addW(4),
            CustomSvgIconButton(
              bgColor: Color(0xffE1F2FF),
              onTap: (){},
              assetPath: AppAssets.downloadIcon,
            ),
            addW(4),
            CustomSvgIconButton(
              bgColor: Color(0xffFFFCF8),
              onTap: (){},
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
                  controller.getStockReportList(page: 1);
                },
                child: PagerListView(
                  items: controller.stockLedgerList,
                  itemBuilder: (_, item) {
                    return Container();
                  },
                  isLoading: controller.isLoadingMore,
                  hasError: controller.hasError,
                  onNewLoad: (int nextPage) async {
                    await controller.getStockReportList(page: nextPage);
                  },
                  totalPage: controller.stockLedgerListResponseModel?.data
                          .pagination.lastPage ??
                      0,
                  totalSize: controller.stockLedgerListResponseModel?.data
                          .pagination.total ??
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

class CustomSvgIconButton extends StatelessWidget {
  const CustomSvgIconButton({
    super.key,
    required this.bgColor,
    required this.onTap,
    required this.assetPath,
  });

  final Color bgColor;
  final String assetPath;
  final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
          radius: 24,
          backgroundColor: bgColor,
          child: SvgPicture.asset(assetPath)),
    );
  }
}
