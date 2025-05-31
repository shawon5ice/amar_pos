import 'package:amar_pos/features/accounting/data/models/money_transfer/money_transfer_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_transfer_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_transfer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import 'money_transfer_controller.dart';

class MoneyTransfer extends StatefulWidget {
  static const routeName = '/accounting/money-transfer';
  const MoneyTransfer({super.key});

  @override
  State<MoneyTransfer> createState() => _MoneyTransferState();
}

class _MoneyTransferState extends State<MoneyTransfer> with SingleTickerProviderStateMixin{

  MoneyTransferController controller = Get.find();


  @override
  void initState() {
    controller.getMoneyTransferList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Money Transfer",),centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                DateTimeRange? selectedDate = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 1000)),
                  lastDate: DateTime.now().add(const Duration(days: 1000)),
                  initialDateRange: controller.selectedDateTimeRange.value,
                );
                controller.selectedDateTimeRange.value = selectedDate;
                controller.getMoneyTransferList();
              },
              icon: SvgPicture.asset(AppAssets.calenderIcon),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // GetBuilder<DueCollectionController>(
                //   id: 'total_widget',
                //   builder: (controller) => Row(
                //     children: [
                //       TotalStatusWidget(
                //         flex: 3,
                //         isLoading: controller.isDueCollectionListLoading,
                //         title: 'Collected From',
                //         value: controller.dueCollectionListResponseModel != null
                //             ? Methods.getFormattedNumber(controller
                //             .dueCollectionListResponseModel!.countTotal
                //             .toDouble())
                //             : null,
                //         asset: AppAssets.person,
                //       ),
                //       addW(12),
                //       TotalStatusWidget(
                //         flex: 4,
                //         isLoading: controller.isDueCollectionListLoading,
                //         title: 'Collection Amount',
                //         value: controller.dueCollectionListResponseModel != null
                //             ? Methods.getFormatedPrice(controller
                //             .dueCollectionListResponseModel!.amountTotal
                //             .toDouble())
                //             : null,
                //         asset: AppAssets.amount,
                //       ),
                //     ],
                //   ),
                // ),
                addH(8),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        textCon: controller.searchController,
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
                          controller.getMoneyTransferList();
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
                // addH(8),
                Obx(() {
                  return controller.selectedDateTimeRange.value == null ? addH(8) : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
                      addW(16),
                      IconButton(onPressed: (){
                        controller.selectedDateTimeRange.value = null;
                        controller.getMoneyTransferList();
                      }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                    ],
                  );
                }),
                Expanded(
                  child: GetBuilder<MoneyTransferController>(
                    id: 'money_transfer_list',
                    builder: (controller) {
                      if (controller.ismoneyTransferListLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }else if(controller.moneyTransferListResponseModel == null){
                        return Center(
                          child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                        );
                      }else if(controller.moneyTransferList.isEmpty){
                        return Center(
                          child: Text("No data found", style: context.textTheme.titleLarge,),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          controller.getMoneyTransferList(page: 1);
                        },
                        child: PagerListView<MoneyTransferData>(
                          // scrollController: _scrollController,
                          items: controller.moneyTransferList,
                          itemBuilder: (_, item) {
                            return MoneyTransferItem(moneyTransferData: item,);
                          },
                          isLoading: controller.isLoadingMore,
                          hasError: controller.hasError.value,
                          onNewLoad: (int nextPage) async {
                            await controller.getMoneyTransferList(page: nextPage);
                          },
                          totalPage: controller
                              .moneyTransferListResponseModel?.data?.meta?.lastPage ?? 0,
                          totalSize:
                          controller
                              .moneyTransferListResponseModel?.data?.meta?.total ??
                              0,
                          itemPerPage: 20,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: CustomButton(
            text: "Transfer Money",
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20)),
                ),
                builder: (context) {
                  return MoneyTransferBottomSheet();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
