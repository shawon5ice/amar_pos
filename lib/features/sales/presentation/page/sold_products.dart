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
import '../../data/models/sold_product/sold_product_response_model.dart';
import '../controller/sales_controller.dart';
import '../widgets/sold_history_item_widget.dart';

class SoldProduct extends StatefulWidget {
  const SoldProduct({super.key});

  @override
  State<SoldProduct> createState() => _SoldHistoryState();
}

class _SoldHistoryState extends State<SoldProduct> {
  final SalesController controller = Get.find();

  @override
  void initState() {
    controller.getSoldProducts();
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
                      controller.getSoldProducts();
                    },
                  ),
                ),
                addW(8),
                CustomSvgIconButton(
                  bgColor: const Color(0xffEBFFDF),
                  onTap: () {
                    controller.downloadList(isPdf: false, saleHistory: false);
                  },
                  assetPath: AppAssets.excelIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadList(isPdf: true, saleHistory: false);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {

                  },
                  assetPath: AppAssets.printIcon,
                )
              ],
            ),
            addH(8),
            GetBuilder<SalesController>(
              id: 'total_products_status_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isSoldProductListLoading,
                    title: 'Total QTY',
                    value: Methods.getFormattedNumber(controller.totalCount.toDouble()),
                    asset: AppAssets.productBox,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isSoldProductListLoading,
                    title: 'Purchase Amount',
                    value: Methods.getFormatedPrice(controller.soldTotalProductAmount),
                    asset: AppAssets.amount,
                  ),
                ],
              ),
            ),
            addH(8),
            Expanded(
              child: GetBuilder<SalesController>(
                id: 'sold_product_list',
                builder: (controller) {
                  if (controller.isSoldProductListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(controller.soldProductResponseModel == null){
                    return Center(
                      child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                    );
                  }else if(controller.soldProductResponseModel!.data.soldProducts.isEmpty){
                    return Center(
                      child: Text("No data found", style: context.textTheme.titleLarge,),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getSoldHistory();
                    },
                    child: PagerListView<SoldProductModel>(
                      // scrollController: _scrollController,
                      items: controller.soldProductList,
                      itemBuilder: (_, item) {
                        return SoldProductListItem(productInfo: item);
                      },
                      isLoading: controller.isSoldProductsLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getSoldProducts(page: nextPage);
                      },
                      totalPage: controller
                          .soldProductResponseModel?.data.meta.lastPage ??
                          0,
                      totalSize:
                      controller.soldProductResponseModel?.data.meta.total ??
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
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(asset)
                ],
              ),
              addH(12),
              isLoading
                  ? Container(
                  height: 30, width: 30, child: CircularProgressIndicator())
                  : Text(
                value != null ? value! : '--',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    height: 1.5
                ),
              )
            ],
          ),
        ));
  }
}
