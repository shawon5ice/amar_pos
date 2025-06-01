import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/accounting/data/models/cash_statement/cash_statement_report_list_reponse_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/cash_statement/cash_statement_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/chart_of_account_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/cash_statement_report_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/methods/helper_methods.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/loading/random_lottie_loader.dart';
import '../../../../../core/widgets/methods/field_validator.dart';
import '../../../../../core/widgets/methods/helper_methods.dart';
import '../../../../../core/widgets/pager_list_view.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../../../core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import '../../../../../core/widgets/reusable/status/total_status_widget.dart';
import '../../../../inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import '../../../data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';

class CashStatement extends StatefulWidget {
  static const routeName = '/accounting/cash_statement';

  const CashStatement({super.key});

  @override
  State<CashStatement> createState() => _CashStatementState();
}

class _CashStatementState extends State<CashStatement> {
  final CashStatementController controller = Get.find();

  ChartOfAccountPaymentMethod? selectedPaymentMethod;
  OutletForMoneyTransferData? selectedAccount;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  int? selectedCaId;

  Future<void> initialize() async {
    await controller.getAccounts().then((value) {
      if (controller.loginData!.businessOwner) {
        selectedPaymentMethod = controller.moneyTransferController.paymentList
            .singleWhere((e) => e.name.toLowerCase().contains('cash'));
        selectedCaId = selectedPaymentMethod!.id;
      } else {
        for (var e in controller.moneyTransferController.toAccounts) {
          logger.e(e.storeId);
        }
        logger.e(controller.loginData!.store.id);
        selectedAccount = controller.moneyTransferController.toAccounts.singleWhere((e) => e.storeId == controller.loginData!.store.id);

        selectedCaId = selectedAccount!.id;
        logger.e(selectedAccount?.id);
      }
      controller.getCashStatementEntryList(caId: selectedCaId!);
      controller.update(['account']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Statement"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              DateTimeRange? selectedDate = await showDateRangePicker(
                context: context,
                firstDate:
                DateTime.now().subtract(const Duration(days: 1000)),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
                initialDateRange: controller.selectedDateTimeRange.value,
              );
              controller.selectedDateTimeRange.value = selectedDate;
              controller.update(['date_status']);
              controller.getCashStatementEntryList(caId: selectedCaId!);
            },
            icon: SvgPicture.asset(AppAssets.calenderIcon),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            GetBuilder<CashStatementController>(
              id: 'account',
              builder: (controller) {
                if (controller.loginData!.businessOwner) {
                  return CustomDropdownWithSearchWidget<
                      ChartOfAccountPaymentMethod>(
                    items: controller.moneyTransferController.paymentList,
                    isMandatory: true,
                    title: "To Account",
                    noTitle: true,
                    itemLabel: (value) => value.name,
                    value: selectedPaymentMethod,
                    onChanged: (value) {
                      selectedPaymentMethod = value;
                      controller
                          .update(['ca_payment_dd']); // Notify UI of the change
                    },
                    hintText: controller
                            .moneyTransferController.paymentListLoading
                        ? "Loading..."
                        : controller.moneyTransferController.paymentList.isEmpty
                            ? "No payment method found..."
                            : "Select ao account",
                    searchHintText: "Search a payment method",
                    validator: (value) =>
                        FieldValidator.nonNullableFieldValidator(
                            value?.name, "To Account"),
                  );
                } else {
                  return CustomDropdownWithSearchWidget<
                      OutletForMoneyTransferData>(
                    items: selectedAccount == null ? [] : [selectedAccount!],
                    isMandatory: true,
                    title: "To Account",
                    noTitle: true,
                    itemLabel: (value) => value.name,
                    value: selectedAccount,
                    onChanged: (value) {
                      // selectedFromAccount = value;
                      // if(selectedFromAccount != null){
                      //   controller.getCABalance(selectedFromAccount!.id);
                      // }
                    },
                    searchHintText: "Search account",
                    hintText: controller.moneyTransferController.outletListLoading
                        ? "Loading..."
                        : controller.moneyTransferController
                                        .outletListForMoneyTransferResponseModel ==
                                    null ||
                                (controller.moneyTransferController
                                            .outletListForMoneyTransferResponseModel !=
                                        null &&
                                    controller
                                            .moneyTransferController
                                            .outletListForMoneyTransferResponseModel!
                                            .data ==
                                        null)
                            ? "No account found"
                            : "Select account",
                    validator: (value) =>
                        FieldValidator.nonNullableFieldValidator(
                            value?.name, "From account"),
                  );
                }
              },
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
                      milliseconds: 500,
                    ),
                    // noInputBorder: true,
                    brdrRadius: 40,
                    prefixWidget: Icon(Icons.search),
                    onChanged: (value){
                      controller.getCashStatementEntryList(caId: selectedCaId!,);
                    },
                  ),
                ),
                addW(8),
                CustomSvgIconButton(
                  bgColor: const Color(0xffEBFFDF),
                  onTap: () {
                    controller.downloadList(isPdf: false,caId: selectedCaId!);
                  },
                  assetPath: AppAssets.excelIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadList(isPdf: true,caId: selectedCaId!);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(4),
                CustomSvgIconButton(
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {
                    controller.downloadList(isPdf: true, caId: selectedCaId!, shouldPrint: true);
                  },
                  assetPath: AppAssets.printIcon,
                )
              ],
            ),
            addH(8),
            GetBuilder<CashStatementController>(
              id: 'total_widget',
              builder: (controller) => Row(
                children: [
                  TotalStatusWidget(
                    flex: 3,
                    isLoading: controller.isCashStatementReportLoading,
                    title: 'Debit',
                    value: controller.isCashStatementReportLoading ? "Loading...":
                    controller.cashStatementEntryListResponseModel == null ? "--" :
                    Methods.getFormattedNumber(controller.cashStatementEntryListResponseModel!.data.first.debit.toDouble()),
                    asset: AppAssets.cashIn,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isCashStatementReportLoading,
                    title: 'Credit',
                    value: controller.isCashStatementReportLoading ? "Loading...":
                    controller.cashStatementEntryListResponseModel == null ? "--" :Methods.getFormattedNumber(controller.cashStatementEntryListResponseModel!.data.first.credit.toDouble()),
                    asset: AppAssets.cashOut,
                  ),
                  addW(12),
                  TotalStatusWidget(
                    flex: 4,
                    isLoading: controller.isCashStatementReportLoading,
                    title: 'Balance',
                    value: controller.isCashStatementReportLoading ? "Loading...":
                    controller.cashStatementEntryListResponseModel == null ? "--" :Methods.getFormattedNumber(controller.cashStatementEntryListResponseModel!.data.first.balance.toDouble()),
                    asset: AppAssets.cash,
                  ),
                ],
              ),
            ),
            addH(8),
            GetBuilder<CashStatementController>(
              id: 'date_status',
              builder: (controller) {
                if(controller.selectedDateTimeRange.value != null){
                  return  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            '${formatDate(controller.selectedDateTimeRange.value!.start)} to ${formatDate(controller.selectedDateTimeRange.value!.end)}',
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.visible,
                            softWrap: false,
                          ),
                          ...[
                            addW(32),
                            GestureDetector(
                              onTap:
                              controller.selectedDateTimeRange.value == null
                                  ? null
                                  : () {
                                controller.selectedDateTimeRange.value =
                                null;
                                controller.update(['date_status']);
                                controller
                                    .getCashStatementEntryList(caId: selectedCaId!);
                              },
                              child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                  controller.selectedDateTimeRange.value !=
                                      null
                                      ? Colors.red
                                      : Colors.transparent,
                                  child: controller.selectedDateTimeRange.value !=
                                      null
                                      ? Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                      : null),
                            ),
                          ],
                        ],
                      ),
                      addH(8),
                    ],
                  );
                }else{
                  return SizedBox.shrink();
                }
              },
            ),
        
            
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async{
                  await controller.getCashStatementEntryList(
                      caId: selectedCaId!,);
                },
                child: GetBuilder<CashStatementController>(
                  id: 'cash_statement_report_list',
                  builder: (controller) {
                    if (controller
                        .isCashStatementReportLoading) {
                      return Center(
                        child: RandomLottieLoader.lottieLoader(),
                      );
                    } else if (controller
                        .cashStatementEntryListResponseModel ==
                        null) {
                      return const Center(
                          child: Text("Something went wrong"));
                    } else if (controller
                        .cashStatementEntryList.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }
                    return PagerListView<CashStatementEntry>(
                      // scrollController: _scrollController,
                      items: controller.cashStatementEntryList,
                      itemBuilder: (_, item) {
                        return CashStatementReportItemWidget(
                          cashStatementReport: item,
                        );
                      },
                      isLoading: controller.isLoadingMore,
                      hasError: controller.hasError.value,
                      onNewLoad: (int nextPage) async {
                        await controller.getCashStatementEntryList(
                            caId: selectedCaId!,
                            page: nextPage);
                      },
                      totalPage: controller
                          .cashStatementEntryListResponseModel
                          ?.data.first.data
                          .lastPage ??
                          0,
                      totalSize: controller.cashStatementEntryListResponseModel
                          ?.data.first.data
                          .total ??
                          0,
                      itemPerPage: 10,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
