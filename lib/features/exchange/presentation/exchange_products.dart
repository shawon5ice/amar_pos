import 'package:amar_pos/features/exchange/data/models/exchange_product_response_model.dart';
import 'package:amar_pos/features/exchange/presentation/widgets/exchange_product_item_widget.dart';
import 'package:amar_pos/features/return/data/models/return_products/return_product_response_model.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/return/presentation/widgets/return_product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/pager_list_view.dart';
import '../../../core/widgets/methods/helper_methods.dart';
import '../../../core/widgets/reusable/status/total_status_widget.dart';
import '../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';
import '../exchange_controller.dart';


class ExchangeProducts extends StatefulWidget {
  const ExchangeProducts({super.key});

  @override
  State<ExchangeProducts> createState() => _SoldHistoryState();
}

class _SoldHistoryState extends State<ExchangeProducts> {
  final ExchangeController controller = Get.find();

  @override
  void initState() {
    controller.getExchangeProducts(
      productType: _selected.first == 'exchange' ? 3 : 2,
    );
    super.initState();
  }

  Set<String> _selected  = {
    'exchange'
  };

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SegmentedButton(
                segments: const [
                ButtonSegment(value: 'exchange', label: Text('Exchange Produccts')),
                ButtonSegment(value: 'return', label: Text('Return Products'))
              ], selected: _selected,
                onSelectionChanged: (value){
                 setState(() {
                   controller.category = null;
                   controller.brand = null;
                   controller.selectedDateTimeRange.value = null;
                   _selected = value;
                   controller.getExchangeProducts(
                     productType: _selected.first == 'exchange' ? 3 : 2,
                   );
                 });
                },
              ),
              addH(8),
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
                        controller.getExchangeProducts();
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
              addH(8),
              GetBuilder<ExchangeController>(
                id: 'total_status_widget',
                builder: (controller) => Row(
                  children: [
                    TotalStatusWidget(
                      flex: 3,
                      isLoading: controller.isExchangeProductListLoading,
                      title: 'Total QTY',
                      value: controller.exchangeProductResponseModel != null
                          ? Methods.getFormattedNumber(controller
                          .exchangeProductResponseModel!.countTotal
                          .toDouble())
                          : null,
                      asset: AppAssets.productBox,
                    ),
                    addW(12),
                    TotalStatusWidget(
                      flex: 4,
                      isLoading: controller.isExchangeProductListLoading,
                      title: 'Total Amount',
                      value: controller.exchangeProductResponseModel != null
                          ? Methods.getFormattedNumber(controller
                          .exchangeProductResponseModel!.amountTotal
                          .toDouble())
                          : null,
                      asset: AppAssets.amount,
                    ),
                  ],
                ),
              ),
              addH(8),
              Expanded(
                child: GetBuilder<ExchangeController>(
                  id: 'exchange_product_list',
                  builder: (controller) {
                    if (controller.isExchangeProductListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if(controller.exchangeProductList.isEmpty){
                      return Center(
                        child: Text("No data found", style: context.textTheme.titleLarge,),
                      );
                    }else if(controller.exchangeProductResponseModel == null){
                      return Center(
                        child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.getExchangeProducts();
                      },
                      child: PagerListView<ExchangeProduct>(
                        // scrollController: _scrollController,
                        items: controller.exchangeProductList,
                        itemBuilder: (_, item) {
                          return ExchangeProductListItem(productInfo: item);
                        },
                        isLoading: controller.isExchangeProductsLoadingMore,
                        hasError: controller.hasError.value,
                        onNewLoad: (int nextPage) async {
                          await controller.getExchangeProducts(page: nextPage);
                        },
                        totalPage: controller
                            .exchangeProductResponseModel?.data.meta.lastPage ??
                            0,
                        totalSize:
                        controller.exchangeProductResponseModel?.data.meta.total ??
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
      ),
    );
  }
}