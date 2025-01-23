import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/features/purchase_return/presentation/purchase_return_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/pager_list_view.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';
import '../../data/models/purchase_return_products_response_model.dart';
import '../widgets/purchase_return_product_item_widget.dart';


class PurchaseReturnProducts extends StatefulWidget {
  const PurchaseReturnProducts({super.key});

  @override
  State<PurchaseReturnProducts> createState() => _SoldHistoryState();
}

class _SoldHistoryState extends State<PurchaseReturnProducts> {
  final PurchaseReturnController controller = Get.find();

  @override
  void initState() {
    controller.getPurchaseReturnProducts();
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
                      milliseconds: 300,
                    ),
                    // noInputBorder: true,
                    brdrRadius: 40,
                    prefixWidget: Icon(Icons.search),
                    onChanged: (value){
                      controller.getPurchaseReturnProducts();
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
                  onTap: () {},
                  assetPath: AppAssets.printIcon,
                )
              ],
            ),
            addH(8.px),
            GetBuilder<PurchaseReturnController>(
              id: 'total_status_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isPurchaseReturnProductListLoading,
                    title: 'Total QTY',
                    value: Methods.getFormattedNumber(controller.purchaseReturnProductResponseModel?.countTotal.toDouble() ?? 0),
                    asset: AppAssets.productBox,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isPurchaseReturnProductListLoading,
                    title: 'Purchase Amount',
                    value: Methods.getFormatedPrice(controller.purchaseReturnProductResponseModel?.amountTotal.toDouble() ?? 0),
                    asset: AppAssets.amount,
                  ),
                ],
              ),
            ),
            addH(8),
            Expanded(
              child: GetBuilder<PurchaseReturnController>(
                id: 'purchase_product',
                builder: (controller) {
                  if (controller.isPurchaseReturnProductListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.purchaseReturnProductResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.purchaseReturnProductResponseModel!.data.returnProducts.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getPurchaseReturnProducts();
                    },
                    child: PagerListView<PurchaseReturnProduct>(
                      // scrollController: _scrollController,
                      items: controller.purchaseReturnProducts,
                      itemBuilder: (_, item) {
                        return PurchaseReturnProductListItem(productInfo: item);
                      },
                      isLoading: controller.isPurchaseReturnProductsLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getPurchaseReturnProducts(page: nextPage);
                      },
                      totalPage: controller
                          .purchaseReturnProductResponseModel?.data.meta.lastPage ??
                          0,
                      totalSize:
                      controller.purchaseReturnProductResponseModel?.data.meta.total ??
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
                      fontSize: 14.sp,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(asset)
                ],
              ),
              addH(12),
              isLoading
                  ? Container(
                  height: 30.sp, width: 30.sp, child: SpinKitFadingGrid(color: Colors.black,size: 20,) )
                  : Text(
                value != null ? value! : '--',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    height: 1.5.sp
                ),
              )
            ],
          ),
        ));
  }
}
