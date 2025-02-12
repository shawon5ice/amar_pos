import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/due_collection/due_collection_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/create_due_collection_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/due_collection_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/methods/helper_methods.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../core/widgets/methods/helper_methods.dart';
import '../../../../../../core/widgets/pager_list_view.dart';
import '../../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../../../../core/widgets/reusable/status/total_status_widget.dart';
import '../../widgets/client_ledger_item.dart';

class ClientLedgerPage extends StatefulWidget {
  const ClientLedgerPage({super.key});

  @override
  State<ClientLedgerPage> createState() => _ClientLedgerPageState();
}

class _ClientLedgerPageState extends State<ClientLedgerPage> {
  DueCollectionController controller = Get.find();


  @override
  void initState() {
    controller.clearFilter();
    controller.getClientLedger(page: 1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              addH(12),
              GetBuilder<DueCollectionController>(
                id: 'client_ledger_total_widget',
                builder: (controller) => Row(
                  children: [
                    TotalStatusWidget(
                      flex: 3,
                      isLoading: controller.isClientLedgerListLoading,
                      title: 'Due Client',
                      value: controller.clientLedgerListResponseModel != null
                          ? Methods.getFormattedNumber(controller
                          .clientLedgerListResponseModel!.countTotal
                          .toDouble())
                          : null,
                      asset: AppAssets.client,
                    ),
                    addW(12),
                    TotalStatusWidget(
                      flex: 4,
                      isLoading: controller.isClientLedgerListLoading,
                      title: 'Due Amount',
                      value: controller.clientLedgerListResponseModel != null
                          ? Methods.getFormatedPrice(controller
                          .clientLedgerListResponseModel!.amountTotal
                          .toDouble())
                          : null,
                      asset: AppAssets.clientMoney,
                    ),
                  ],
                ),
              ),
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
                        controller.getClientLedger();
                      },
                    ),
                  ),
                  addW(8),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffEBFFDF),
                    onTap: () {
                      controller.downloadList(isPdf: false, clientLedger: true);
                    },
                    assetPath: AppAssets.excelIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffE1F2FF),
                    onTap: () {
                      controller.downloadList(isPdf: true, clientLedger: true);
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
              Obx(() {
                return controller.selectedDateTimeRange.value == null ? addH(8): Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
                    addW(16),
                    IconButton(onPressed: (){
                      controller.selectedDateTimeRange.value = null;
                      controller.getClientLedger();
                    }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                  ],
                );
              }),
              Expanded(
                child: GetBuilder<DueCollectionController>(
                  id: 'client_ledger',
                  builder: (controller) {
                    if (controller.isClientLedgerListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if(controller.clientLedgerListResponseModel == null){
                      return Center(
                        child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                      );
                    }else if(controller.clientLedgerList.isEmpty){
                      return Center(
                        child: Text("No data found", style: context.textTheme.titleLarge,),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.getClientLedger(page: 1);
                      },
                      child: PagerListView<ClientLedgerData>(
                        // scrollController: _scrollController,
                        items: controller.clientLedgerList,
                        itemBuilder: (_, item) {
                          return ClientLedgerItem(clientLedgerData: item,);
                        },
                        isLoading: controller.isClientLedgerListLoadingMore,
                        hasError: controller.hasError.value,
                        onNewLoad: (int nextPage) async {
                          await controller.getClientLedger(page: nextPage);
                        },
                        totalPage: controller
                            .clientLedgerListResponseModel?.data?.meta?.lastPage ?? 0,
                        totalSize:
                        controller
                            .clientLedgerListResponseModel?.data?.meta?.total ??
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
          child: CustomButton(
            text: "Collect Due",
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20)),
                ),
                builder: (context) {
                  return CreateDueCollectionBottomSheet();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
