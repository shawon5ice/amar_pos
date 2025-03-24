import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/reusable/forbidden_access_full_screen_widget.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_product_response_model.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:amar_pos/features/purchase/presentation/widgets/purchase_product_item_widget.dart';
import 'package:amar_pos/permission_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/methods/helper_methods.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/pager_list_view.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';


class PurchaseProducts extends StatefulWidget {
  const PurchaseProducts({super.key});

  @override
  State<PurchaseProducts> createState() => _SoldHistoryState();
}

class _SoldHistoryState extends State<PurchaseProducts> {
  final PurchaseController controller = Get.find();

  @override
  void initState() {
    if(controller.productAccess){
      controller.getPurchaseProducts();
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
        body:  !controller.productAccess ? const ForbiddenAccessFullScreenWidget() : Column(
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
                      controller.getPurchaseProducts();
                    },
                  ),
                ),
                addW(8),
                CustomSvgIconButton(
                  bgColor: const Color(0xffEBFFDF),
                  onTap: () {
                    controller.downloadList(isPdf: false, purchaseHistory: false);
                  },
                  assetPath: AppAssets.excelIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadList(isPdf: true, purchaseHistory: false);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {
                    controller.downloadList(isPdf: true, purchaseHistory: false,shouldPrint: true);
                  },
                  assetPath: AppAssets.printIcon,
                )
              ],
            ),
            addH(8.px),
            GetBuilder<PurchaseController>(
              id: 'total_status_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isPurchaseProductListLoading,
                    title: 'Total QTY',
                    value: Methods.getFormattedNumber(controller.countTotal.toDouble() ?? 0),
                    asset: AppAssets.productBox,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isPurchaseProductListLoading,
                    title: 'Purchase Amount',
                    value: Methods.getFormatedPrice(controller.purchaseAmount.toDouble() ?? 0),
                    asset: AppAssets.amount,
                  ),
                ],
              ),
            ),
            addH(8.h),
            // Obx(() {
            //   return controller.selectedDateTimeRange.value == null ? addH(8) : Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
            //       addW(16),
            //       IconButton(onPressed: (){
            //         controller.selectedDateTimeRange.value = null;
            //         controller.getPurchaseProducts();
            //       }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
            //     ],
            //   );
            // }),
            Expanded(
              child: GetBuilder<PurchaseController>(
                id: 'purchase_product',
                builder: (controller) {
                  if (controller.isPurchaseProductListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.purchaseProductResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.purchaseProducts.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getPurchaseProducts();
                    },
                    child: PagerListView<PurchaseProduct>(
                      // scrollController: _scrollController,
                      items: controller.purchaseProducts,
                      itemBuilder: (_, item) {
                        return PurchaseProductListItem(productInfo: item);
                      },
                      isLoading: controller.isPurchaseProductsLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getPurchaseProducts(page: nextPage);
                      },
                      totalPage: controller
                          .purchaseProductResponseModel?.data.meta!.lastPage ??
                          0,
                      totalSize:
                      controller.purchaseProductResponseModel?.data.meta!.total ??
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
                  height: 30.sp, width: 30.sp, child: SpinKitFadingGrid(color: Colors.black,size: 20,) )
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
