import 'package:amar_pos/core/core.dart';
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
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';
import '../../data/models/purchase_return_history_response_model.dart';
import '../purchase_return_controller.dart';
import '../widgets/purchase_return_history_item_widget.dart';

class PurchaseReturnHistoryScreen extends StatefulWidget {
  PurchaseReturnHistoryScreen({super.key, required this.onChange});
  Function(int value) onChange;

  @override
  State<PurchaseReturnHistoryScreen> createState() => _PurchaseReturnHistoryScreenState();
}

class _PurchaseReturnHistoryScreenState extends State<PurchaseReturnHistoryScreen> {
  final PurchaseReturnController controller = Get.find();

  @override
  void initState() {
    controller.getPurchaseReturnHistory();
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
        body: !controller.historyAccess ? ForbiddenAccessFullScreenWidget() : Column(
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
                      controller.getPurchaseReturnHistory();
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
                    controller.downloadList(isPdf: true, purchaseHistory: true,shouldPrint: true);
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
                    controller.getPurchaseReturnHistory();
                  }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                ],
              );
            }),
            GetBuilder<PurchaseReturnController>(
              id: 'total_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isPurchaseReturnHistoryListLoading,
                    title: 'Invoice',
                    value: controller.purchaseReturnHistoryResponseModel != null
                        ? Methods.getFormattedNumber(controller
                        .purchaseReturnHistoryResponseModel!.countTotal
                        .toDouble())
                        : null,
                    asset: AppAssets.invoice,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isPurchaseReturnHistoryListLoading,
                    title: 'Total Amount',
                    value: controller.purchaseReturnHistoryResponseModel != null
                        ? Methods.getFormatedPrice(controller
                        .purchaseReturnHistoryResponseModel!.amountTotal
                        .toDouble())
                        : null,
                    asset: AppAssets.amount,
                  ),
                ],
              ),
            ),
            addH(8),
            Expanded(
              child: GetBuilder<PurchaseReturnController>(
                id: 'purchase_history_list',
                builder: (controller) {
                  if (controller.isPurchaseReturnHistoryListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.purchaseReturnHistoryList.isEmpty && controller.hasError.value == false){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.purchaseReturnHistoryResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getPurchaseReturnHistory();
                    },
                    child: PagerListView<PurchaseReturnOrderInfo>(
                      // scrollController: _scrollController,
                      items: controller.purchaseReturnHistoryList,
                      itemBuilder: (_, item) {
                        return PurchaseReturnHistoryItemWidget(purchaseReturnHistory: item,onChange: (value) {
                          widget.onChange(value);
                        },);
                      },
                      isLoading: controller.isPurchaseReturnHistoryLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getPurchaseReturnHistory(page: nextPage);
                      },
                      totalPage: controller
                          .purchaseReturnHistoryResponseModel?.data.meta?.lastPage ??
                          0,
                      totalSize:
                      controller.purchaseReturnHistoryResponseModel?.data.meta?.total ??
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