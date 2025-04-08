import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/data/models/stock_transfer_history_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/pages/widgets/stock_transfer_history_item_widget.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/stock_transfer_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../../../core/widgets/reusable/forbidden_access_full_screen_widget.dart';


class StockTransferHistoryScreen extends StatefulWidget {
  StockTransferHistoryScreen({super.key, required this.onChange});
  Function(int value) onChange;

  @override
  State<StockTransferHistoryScreen> createState() => _StockTransferHistoryScreenState();
}

class _StockTransferHistoryScreenState extends State<StockTransferHistoryScreen> {
  final StockTransferController controller = Get.find();

  @override
  void initState() {
    if(controller.historyAccess){
      controller.getStockTransferHistory();
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
        body:  !controller.historyAccess ? const ForbiddenAccessFullScreenWidget()  :Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    textCon: controller.searchProductController,
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
                      controller.getStockTransferHistory();
                    },
                  ),
                ),
                addW(8),
                CustomSvgIconButton(
                  bgColor: const Color(0xffEBFFDF),
                  onTap: () {
                    controller.downloadList(isPdf: false,);
                  },
                  assetPath: AppAssets.excelIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadList(isPdf: true,);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {
                    controller.downloadList(isPdf: true, shouldPrint: true);
                  },
                  assetPath: AppAssets.printIcon,
                )
              ],
            ),
            Obx(() {
              return controller.selectedDateTimeRange.value == null ? addH(8) : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
                  addW(16),
                  IconButton(onPressed: (){
                    controller.selectedDateTimeRange.value = null;
                    controller.getStockTransferHistory();
                  }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                ],
              );
            }),
            Expanded(
              child: GetBuilder<StockTransferController>(
                id: 'purchase_history_list',
                builder: (controller) {
                  if (controller.isStockTransferHistoryListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.stockTransferHistory.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.stockTransferResponse == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getStockTransferHistory();
                    },
                    child: PagerListView<StockTransfer>(
                      // scrollController: _scrollController,
                      items: controller.stockTransferHistory,
                      itemBuilder: (_, item) {
                        return StockTransferHistoryItemWidget(stockTransfer: item,onChange: (value) {
                          widget.onChange(value);
                        },);
                      },
                      isLoading: controller.isStockTransferHistoryListLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getStockTransferHistory(page: nextPage);
                      },
                      totalPage: controller
                          .stockTransferResponse?.data.meta.lastPage ??
                          0,
                      totalSize:
                      controller.stockTransferResponse?.data.meta.total ??
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

class TotalStatusWidget extends StatelessWidget {
  const TotalStatusWidget({
    super.key,
    required this.title,
    this.value,
    required this.isLoading,
    required this.asset,
    this.flex = 1,
  });

  final String title;
  final String? value;
  final bool isLoading;
  final String asset;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xffA2A2A2),
                      fontSize: 12.sp,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(asset)
                ],
              ),
              addH(8.h),
              isLoading
                  ? Container(
                  height: 30.sp, width: 30.sp, child: SpinKitFadingGrid(color: Colors.black,size: 20,))
                  : Text(
                value != null ? value! : '--',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    height: 1.5.sp
                ),
              )
            ],
          ),
        ));
  }
}
