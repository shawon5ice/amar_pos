import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/methods/helper_methods.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/pager_list_view.dart';
import '../../../../core/widgets/reusable/forbidden_access_full_screen_widget.dart';
import '../../../../permission_manager.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';
import '../widgets/purchase_history_item_widget.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  PurchaseHistoryScreen({super.key, required this.onChange});
  Function(int value) onChange;

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final PurchaseController controller = Get.find();

  @override
  void initState() {
    if(controller.historyAccess){
      controller.getPurchaseHistory();
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
                      controller.getPurchaseHistory();
                    },
                  ),
                ),
                addW(8),
                CustomSvgIconButton(
                  bgColor: const Color(0xffEBFFDF),
                  onTap: () {
                    controller.downloadList(isPdf: false, purchaseHistory: true);
                    // controller.downloadStockLedgerReport(
                    //     isPdf: false, context: context);
                  },
                  assetPath: AppAssets.excelIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadList(isPdf: true, purchaseHistory: true);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {
                    controller.downloadList(isPdf: true, purchaseHistory: true, shouldPrint: true);
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
                    controller.getPurchaseHistory();
                  }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                ],
              );
            }),
            GetBuilder<PurchaseController>(
              id: 'total_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isPurchaseHistoryListLoading,
                    title: 'Invoice',
                    value: controller.purchaseHistoryResponseModel != null
                        ? Methods.getFormattedNumber(controller
                        .purchaseHistoryResponseModel!.countTotal
                        .toDouble())
                        : null,
                    asset: AppAssets.invoice,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isPurchaseHistoryListLoading,
                    title: 'Total Amount',
                    value: controller.purchaseHistoryResponseModel != null
                        ? Methods.getFormatedPrice(controller
                        .purchaseHistoryResponseModel!.amountTotal
                        .toDouble())
                        : null,
                    asset: AppAssets.amount,
                  ),
                ],
              ),
            ),
            addH(8),
            Expanded(
              child: GetBuilder<PurchaseController>(
                id: 'purchase_history_list',
                builder: (controller) {
                  if (controller.isPurchaseHistoryListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.purchaseHistoryResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.purchaseHistoryResponseModel!.data.purchaseHistoryList.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getPurchaseHistory();
                    },
                    child: PagerListView<PurchaseOrderInfo>(
                      // scrollController: _scrollController,
                      items: controller.purchaseHistoryList,
                      itemBuilder: (_, item) {
                        return PurchaseHistoryItemWidget(purchaseHistory: item,onChange: (value) {
                          widget.onChange(value);
                        },);
                      },
                      isLoading: controller.isPurchaseHistoryLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getPurchaseHistory(page: nextPage);
                      },
                      totalPage: controller
                          .purchaseHistoryResponseModel?.data.meta?.lastPage ??
                          0,
                      totalSize:
                      controller.purchaseHistoryResponseModel?.data.meta?.total ??
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