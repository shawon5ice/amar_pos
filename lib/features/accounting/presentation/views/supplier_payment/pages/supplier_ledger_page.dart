import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_ledger/supplier_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/create_due_collection_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/supplier_ledger_item.dart';
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
import '../supplier_payment_controller.dart';

class SupplierLedgerPage extends StatefulWidget {
  const SupplierLedgerPage({super.key});

  @override
  State<SupplierLedgerPage> createState() => _SupplierLedgerPageState();
}

class _SupplierLedgerPageState extends State<SupplierLedgerPage> {
  SupplierPaymentController controller = Get.find();


  @override
  void initState() {
    controller.clearFilter();
    controller.getSupplierLedger(page: 1);
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
              GetBuilder<SupplierPaymentController>(
                id: 'supplier_ledger_total_widget',
                builder: (controller) => Row(
                  children: [
                    TotalStatusWidget(
                      flex: 3,
                      isLoading: controller.isSupplierLedgerListLoading,
                      title: 'Due Client',
                      value: controller.supplierLedgerListResponseModel != null
                          ? Methods.getFormattedNumber(controller
                          .supplierLedgerListResponseModel!.countTotal
                          .toDouble())
                          : null,
                      asset: AppAssets.client,
                    ),
                    addW(12),
                    TotalStatusWidget(
                      flex: 4,
                      isLoading: controller.isSupplierLedgerListLoading,
                      title: 'Due Amount',
                      value: controller.supplierLedgerListResponseModel != null
                          ? Methods.getFormatedPrice(controller
                          .supplierLedgerListResponseModel!.amountTotal
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
                        controller.getSupplierLedger();
                      },
                    ),
                  ),
                  addW(8),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffEBFFDF),
                    onTap: () {
                      controller.downloadList(isPdf: false, supplierLedger: true);
                    },
                    assetPath: AppAssets.excelIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffE1F2FF),
                    onTap: () {
                      controller.downloadList(isPdf: true, supplierLedger: true);
                    },
                    assetPath: AppAssets.downloadIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffFFFCF8),
                    onTap: () {
                      controller.downloadList(isPdf: false, supplierLedger: true, shouldPrint: true);
                    },
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
                      controller.getSupplierLedger();
                    }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                  ],
                );
              }),
              Expanded(
                child: GetBuilder<SupplierPaymentController>(
                  id: 'supplier_ledger',
                  builder: (controller) {
                    if (controller.isSupplierLedgerListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if(controller.supplierPaymentListResponseModel == null){
                      return Center(
                        child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                      );
                    }else if(controller.supplierLedgerList.isEmpty){
                      return Center(
                        child: Text("No data found", style: context.textTheme.titleLarge,),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.getSupplierLedger(page: 1);
                      },
                      child: PagerListView<SupplierLedgerData>(
                        // scrollController: _scrollController,
                        items: controller.supplierLedgerList,
                        itemBuilder: (_, item) {
                          return SupplierLedgerItem(supplierLedgerData: item,);
                        },
                        isLoading: controller.isSupplierLedgerListLoadingMore,
                        hasError: controller.hasError.value,
                        onNewLoad: (int nextPage) async {
                          await controller.getSupplierLedger(page: nextPage);
                        },
                        totalPage: controller
                            .supplierPaymentListResponseModel?.data?.meta?.lastPage ?? 0,
                        totalSize:
                        controller
                            .supplierPaymentListResponseModel?.data?.meta?.total ??
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
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
        //   child: CustomButton(
        //     text: "Collect Due",
        //     onTap: () {
        //       showModalBottomSheet(
        //         context: context,
        //         isScrollControlled: true,
        //         shape: const RoundedRectangleBorder(
        //           borderRadius: BorderRadius.vertical(
        //               top: Radius.circular(20)),
        //         ),
        //         builder: (context) {
        //           return CreateDueCollectionBottomSheet();
        //         },
        //       );
        //     },
        //   ),
        // ),
      ),
    );
  }
}
