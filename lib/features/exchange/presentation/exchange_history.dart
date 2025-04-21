import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/exchange/data/models/exchange_history_response_model.dart';
import 'package:amar_pos/features/exchange/exchange_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/methods/helper_methods.dart';
import '../../../core/responsive/pixel_perfect.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/pager_list_view.dart';
import '../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';
import 'widgets/exchange_history_item_widget.dart';

class ExchangeHistoryScreen extends StatefulWidget {
  final Function(int value) onChange;
  const ExchangeHistoryScreen({super.key, required this.onChange});

  @override
  State<ExchangeHistoryScreen> createState() => _ExchangeHistoryScreenState();
}

class _ExchangeHistoryScreenState extends State<ExchangeHistoryScreen> {
  final ExchangeController controller = Get.find();

  @override
  void initState() {
    controller.getExchangeHistory();
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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
                        controller.getExchangeHistory();
                      },
                    ),
                  ),
                  addW(8),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffEBFFDF),
                    onTap: () {
                      controller.downloadList(isPdf: false, returnHistory: true);
                      // controller.downloadStockLedgerReport(
                      //     isPdf: false, context: context);
                    },
                    assetPath: AppAssets.excelIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffE1F2FF),
                    onTap: () {
                      controller.downloadList(isPdf: true, returnHistory: true);
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
              // addH(8.px),
              // GetBuilder<ExchangeController>(
              //   id: 'total_widget',
              //   builder: (controller) => Row(
              //     children: [
              //       TotalStatusWidget(
              //         flex: 3,
              //         isLoading: controller.isExchangeHistoryListLoading,
              //         title: 'Invoice',
              //         value: controller.exchangeHistoryResponseModel != null
              //             ? Methods.getFormattedNumber(controller
              //             .exchangeHistoryResponseModel!.data.exchangeHistoryList.length
              //             .toDouble())
              //             : null,
              //         asset: AppAssets.invoice,
              //       ),
              //       addW(12),
              //       TotalStatusWidget(
              //         flex: 4,
              //         isLoading: controller.isReturnHistoryListLoading,
              //         title: 'Returned Amount',
              //         value: controller.returnHistoryResponseModel != null
              //             ? Methods.getFormatedPrice(controller
              //             .returnHistoryResponseModel!.amountTotal
              //             .toDouble())
              //             : null,
              //         asset: AppAssets.amount,
              //       ),
              //     ],
              //   ),
              // ),
              Obx(() {
                return controller.selectedDateTimeRange.value == null ? addH(0): Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
                    addW(16),
                    IconButton(onPressed: (){
                      controller.selectedDateTimeRange.value = null;
                      controller.getExchangeHistory();
                    }, icon: Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                  ],
                );
              }),

              Expanded(
                child: GetBuilder<ExchangeController>(
                  id: 'return_history_list',
                  builder: (controller) {
                    if (controller.isExchangeHistoryListLoading) {
                      return RandomLottieLoader.lottieLoader();
                    }else if(controller.exchangeHistoryList.isEmpty){
                      return Center(
                        child: Text("No data found", style: context.textTheme.titleLarge,),
                      );
                    }else if(controller.exchangeHistoryResponseModel == null){
                      return Center(
                        child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.getExchangeHistory(page: 1);
                      },
                      child: PagerListView<ExchangeOrderInfo>(
                        // scrollController: _scrollController,
                        items: controller.exchangeHistoryList,
                        itemBuilder: (_, item) {
                          return ExchangeHistoryItemWidget(exchangeOrderInfo: item,onChange: (value){
                            widget.onChange(value);
                          },);
                        },
                        isLoading: controller.isReturnHistoryLoadingMore,
                        hasError: controller.hasError.value,
                        onNewLoad: (int nextPage) async {
                          await controller.getExchangeHistory(page: nextPage);
                        },
                        totalPage: controller
                            .exchangeHistoryResponseModel?.data.meta.lastPage ??
                            0,
                        totalSize:
                        controller.exchangeHistoryResponseModel?.data.meta.total ??
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
                  height: 30.sp, width: 30.sp, child: SpinKitFadingGrid(color: Colors.black,size: 20,))
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
