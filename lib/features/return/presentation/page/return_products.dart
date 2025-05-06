import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/core/widgets/reusable/status/total_status_widget.dart';
import 'package:amar_pos/features/return/data/models/return_products/return_product_response_model.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/return/presentation/widgets/return_product_item_widget.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/pager_list_view.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';


class ReturnProducts extends StatefulWidget {
  const ReturnProducts({super.key});

  @override
  State<ReturnProducts> createState() => _SoldHistoryState();
}

class _SoldHistoryState extends State<ReturnProducts> {
  final ReturnController controller = Get.find();

  @override
  void initState() {
    controller.getReturnProducts();
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
                      controller.getReturnProducts();
                    },
                  ),
                ),
                addW(8),
                CustomSvgIconButton(
                  bgColor: const Color(0xffEBFFDF),
                  onTap: () {
                    controller.downloadList(isPdf: false, returnHistory: false);
                  },
                  assetPath: AppAssets.excelIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadList(isPdf: true, returnHistory: false);
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
            GetBuilder<ReturnController>(
              id: 'total_status_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isReturnProductListLoading,
                    title: 'Total QTY',
                    value: controller.returnProductResponseModel != null
                  ? Methods.getFormattedNumber(controller
                    .returnProductResponseModel!.countTotal
                    .toDouble())
                    : null,
                    asset: AppAssets.productBox,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isReturnProductListLoading,
                    title: 'Amount',
                    value: controller.returnProductResponseModel != null
                        ? Methods.getFormattedNumber(controller
                        .returnProductResponseModel!.amountTotal
                        .toDouble())
                        : null,
                    asset: AppAssets.amount,
                  ),
                ],
              ),
            ),
            addH(8),
            Expanded(
              child: GetBuilder<ReturnController>(
                id: 'return_product_list',
                builder: (controller) {
                  if (controller.isReturnProductListLoading) {
                    return Center(
                      child: RandomLottieLoader.lottieLoader(),
                    );
                  }else if(controller.returnProductResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.returnProductResponseModel!.data.returnProducts.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getReturnProducts();
                    },
                    child: PagerListView<ReturnProduct>(
                      // scrollController: _scrollController,
                      items: controller.soldProductList,
                      itemBuilder: (_, item) {
                        return ReturnProductListItem(productInfo: item);
                      },
                      isLoading: controller.isReturnProductListLoading,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getReturnProducts(page: nextPage);
                      },
                      totalPage: controller
                          .returnProductResponseModel?.data.meta.lastPage ??
                          0,
                      totalSize:
                      controller.returnProductResponseModel?.data.meta.total ??
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
