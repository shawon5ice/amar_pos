import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/book_ledger/book_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/trial_balance/trial_balance_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/book_ledger_service.dart';
import 'package:amar_pos/features/accounting/data/services/due_collection_service.dart';
import 'package:amar_pos/features/accounting/data/services/money_adjustment_service.dart';
import 'package:amar_pos/features/accounting/data/services/money_transfer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/core.dart';
import '../../../../../core/network/base_client.dart';
import '../../../../../core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';
import '../../../data/services/trial_balance_service.dart';

class TrialBalanceController extends GetxController{

  bool trialBalanceListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  TextEditingController searchController = TextEditingController();

  int? selectedOutletId;
  Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);

  // List<MoneyAdjustmentData> trialBalanceList = [];
  // MoneyAdjustmentListResponseModel? MoneyAdjustmentListResponseModel;

  List<TrialBalance> trialBalanceList = [];
  TrialBalanceListResponseModel? trialBalanceListResponseModel;




  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  void onReady() {
    super.onReady();
    getBookLedger();
  }


  void setSelectedDateRange(DateTime? date) {
    selectedDateTime.value = date;
    update(['selection_status']);
  }

  void clearFilter(){
    searchController.clear();
    selectedDateTime.value = null;
    update(['selection_status']);
  }

  Future<void> getBookLedger(
      {int page = 1,}) async {
    trialBalanceListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      trialBalanceList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','trial_balance_list']);

    try {
      var response = await TrialBalanceService.getTrialBalance(
        usrToken: loginData!.token,
        page: page,
        search: searchController.text,
        endDate: selectedDateTime.value?.toString(),
      );

      if (response != null) {
        trialBalanceListResponseModel =
            TrialBalanceListResponseModel.fromJson(response);

        logger.d(trialBalanceListResponseModel?.data);
        if (trialBalanceListResponseModel != null && trialBalanceListResponseModel!.data != null) {
          trialBalanceList.addAll(trialBalanceListResponseModel!.data!.first.trialBalanceList!);
          logger.i(trialBalanceList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          trialBalanceList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        trialBalanceList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      trialBalanceList.clear();
      logger.e(e);
    } finally {
      trialBalanceListLoading = false;
      isLoadingMore = false;
      update(['total_widget','trial_balance_list']);
    }
  }


  bool isAddOrUpdateLoading = false;


  //Client Ledger

  bool isClientLedgerListLoading = false;
  bool isClientLedgerListLoadingMore = false;


  bool downloadLoading = false;

  Future<void> downloadList({required bool isPdf, bool? shouldPrint}) async {
    if(trialBalanceList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be ${shouldPrint != null ? 'printed': 'downloaded'} with empty data");
      return;
    }
    if(downloadLoading){
      return;
    }
    downloadLoading = true;

    hasError.value = false;

    String fileName = "Trial Balance of -${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await TrialBalanceService.downloadList(
        isPdf: isPdf,
        usrToken: loginData!.token,
        search: searchController.text,
        endDate: selectedDateTime.value,
        fileName: fileName,
        shouldPrint: shouldPrint,
      );
    } catch (e) {
      logger.e(e);
    } finally {
      downloadLoading = false;
    }
  }

  Future<void> downloadMoneyTransferInvoice({required bool isPdf, required int invoiceID, required String invoiceNo, bool? shouldPrint}) async {
    hasError.value = false;

    String fileName = "$invoiceNo${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await MoneyAdjustmentService.downloadMoneyAdjustmentInvoice(
        invoiceID: invoiceID,
        isPdf: isPdf,
        usrToken: loginData!.token,
        fileName: fileName,
        shouldPrint: shouldPrint,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }

  bool outletListLoading = false;
  OutletListForMoneyTransferResponseModel? outletListForMoneyTransferResponseModel;

  Future<void> getOutletForMoneyTransferList() async {
    outletListLoading = true;
    hasError.value = false;
    update(['outlet_list_for_money_transfer']);

    try {
      var response = await MoneyTransferService.getOutletForMoneyTransferList(
        usrToken: loginData!.token,
      );

      if (response != null) {
        outletListForMoneyTransferResponseModel =
            OutletListForMoneyTransferResponseModel.fromJson(response);
      } else {
        trialBalanceList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      trialBalanceList.clear();
      logger.e(e);
    } finally {
      outletListLoading = false;
      update(['outlet_list_for_money_transfer']);
    }
  }

  bool paymentListLoading = false;
  List<ChartOfAccountPaymentMethod> paymentList = [];
  ChartOfAccountPaymentMethod? selectedCAPaymentMethod;


  Future<void> getAllPaymentMethods({ChartOfAccountPaymentMethod? account, int? id}) async {
    paymentListLoading = true;
    logger.e("GETTING PAYMENTS");
    update(['ca_payment_dd']); // Update the UI for loading state
    var response = await BaseClient.getData(
      token: loginData!.token,
      api: "chart_of_accounts/get-payment-methods",
    );

    logger.d(response);

    if (response != null) {
      ChartOfAccountPaymentMethodsResponseModel chartOfAccountPaymentMethodsResponseModel =
      ChartOfAccountPaymentMethodsResponseModel.fromJson(response);
      paymentList = chartOfAccountPaymentMethodsResponseModel.paymentMethods;
      logger.d(id);
      // if(account != null){
      //   selectedCAPaymentMethod = paymentList.singleWhere((e) => e.id == account.id);
      // }
      //
      // if(id != null){
      //   selectedCAPaymentMethod = paymentList.singleWhere((e) => e.id == id);
      // }

    }
    paymentListLoading = false;
    update(['ca_payment_dd']); // Update the UI after loading
  }
}