import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_payment/supplier_payment_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/create_due_collection_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/make_supplier_payment_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/supplier_payment_item.dart';
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

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  SupplierPaymentController controller = Get.find();


  @override
  void initState() {
    controller.getSupplierPaymentList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Scaffold(
          body: Column(
            children: [
              addH(12),
              GetBuilder<SupplierPaymentController>(
                id: 'total_widget',
                builder: (controller) => Row(
                  children: [
                    TotalStatusWidget(
                      flex: 3,
                      isLoading: controller.isSupplierPaymentListLoading,
                      title: 'Paid To',
                      value: controller.supplierPaymentListResponseModel != null
                          ? Methods.getFormattedNumber(controller
                          .supplierPaymentListResponseModel!.countTotal
                          .toDouble())
                          : null,
                      asset: AppAssets.person,
                    ),
                    addW(12),
                    TotalStatusWidget(
                      flex: 4,
                      isLoading: controller.isSupplierPaymentListLoading,
                      title: 'Paid Amount',
                      value: controller.supplierPaymentListResponseModel != null
                          ? Methods.getFormatedPrice(controller
                          .supplierPaymentListResponseModel!.amountTotal
                          .toDouble())
                          : null,
                      asset: AppAssets.amount,
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
                        controller.getSupplierPaymentList();
                      },
                    ),
                  ),
                  addW(8),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffEBFFDF),
                    onTap: () {
                      controller.downloadList(isPdf: false, supplierLedger: false);
                    },
                    assetPath: AppAssets.excelIcon,
                  ),
                  addW(4),
                  CustomSvgIconButton(
                    bgColor: const Color(0xffE1F2FF),
                    onTap: () {
                      controller.downloadList(isPdf: true, supplierLedger: false);
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
              Obx(() {
                return controller.selectedDateTimeRange.value == null ? addH(8) : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${formatDate(controller.selectedDateTimeRange.value!.start)} - ${formatDate(controller.selectedDateTimeRange.value!.end)}", style:const TextStyle(fontSize: 14, color: AppColors.error),),
                    addW(16),
                    IconButton(onPressed: (){
                      controller.selectedDateTimeRange.value = null;
                      controller.getSupplierPaymentList();
                    }, icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.error,))
                  ],
                );
              }),
              Expanded(
                child: GetBuilder<SupplierPaymentController>(
                  id: 'supplier_payment_list',
                  builder: (controller) {
                    if (controller.isSupplierPaymentListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if(controller.supplierPaymentListResponseModel == null){
                      return Center(
                        child: Text("Something went wrong", style: context.textTheme.titleLarge,),
                      );
                    }else if(controller.supplierPaymentList.isEmpty){
                      return Center(
                        child: Text("No data found", style: context.textTheme.titleLarge,),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.getSupplierPaymentList(page: 1);
                      },
                      child: PagerListView<SupplierPaymentData>(
                        // scrollController: _scrollController,
                        items: controller.supplierPaymentList,
                        itemBuilder: (_, item) {
                          return SupplierPaymentItem(supplierPaymentData: item,);
                        },
                        isLoading: controller.isLoadingMore,
                        hasError: controller.hasError.value,
                        onNewLoad: (int nextPage) async {
                          await controller.getSupplierPaymentList(page: nextPage);
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
            child: CustomButton(
              text: "Make Payment",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return MakeSupplierPaymentBottomSheet();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
