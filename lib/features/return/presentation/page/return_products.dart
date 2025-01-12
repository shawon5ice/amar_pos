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
            addH(8.px),
            GetBuilder<ReturnController>(
              id: 'total_status_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isReturnHistoryListLoading,
                    title: 'Total QTY',
                    value: null,
                    asset: AppAssets.productBox,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isReturnHistoryListLoading,
                    title: 'Sold Amount',
                    value: null,
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
                    return const Center(
                      child: CircularProgressIndicator(),
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
                  height: 30.sp, width: 30.sp, child: CircularProgressIndicator())
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
