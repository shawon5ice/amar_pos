import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/book_ledger/book_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/trial_balance/trial_balance_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/book_ledger_service.dart';
import 'package:amar_pos/features/accounting/data/services/due_collection_service.dart';
import 'package:amar_pos/features/accounting/data/services/money_adjustment_service.dart';
import 'package:amar_pos/features/accounting/data/services/money_transfer_service.dart';
import 'package:amar_pos/features/accounting/data/services/profit_or_loss_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/core.dart';
import '../../../../../core/network/base_client.dart';
import '../../../../../core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';
import '../../../data/models/profit_or_loss/profit_or_loss_list_response_model.dart';
import '../../../data/services/trial_balance_service.dart';

class ProfitOrLossController extends GetxController{

  bool profitOrLossListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  TextEditingController searchController = TextEditingController();

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  // List<MoneyAdjustmentData> profitOrLossList = [];
  // MoneyAdjustmentListResponseModel? MoneyAdjustmentListResponseModel;

  List<ProfitOrLoss> profitOrLossList = [];
  ProfitOrLossListResponseModel? profitOrLossListResponseModel;




  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  void onReady() {
    super.onReady();
    getBookLedger();
  }


  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
    update(['selection_status']);
  }

  void clearFilter(){
    searchController.clear();
    selectedDateTimeRange.value = null;
    update(['selection_status']);
  }

  Future<void> getBookLedger(
      {int page = 1,}) async {
    profitOrLossListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      profitOrLossList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','profit_or_loss_list']);

    try {
      var response = await ProfitOrLossService.getProfitOrLoss(
        usrToken: loginData!.token,
        page: page,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      if (response != null) {
        profitOrLossListResponseModel =
            ProfitOrLossListResponseModel.fromJson(response);

        if (profitOrLossListResponseModel != null && profitOrLossListResponseModel!.data != null) {
          profitOrLossList.addAll(profitOrLossListResponseModel!.data!);
          logger.i(profitOrLossList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          profitOrLossList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        profitOrLossList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      profitOrLossList.clear();
      logger.e(e);
    } finally {
      profitOrLossListLoading = false;
      isLoadingMore = false;
      update(['total_widget','profit_or_loss_list']);
    }
  }


  bool isAddOrUpdateLoading = false;


  //Client Ledger

  bool isClientLedgerListLoading = false;
  bool isClientLedgerListLoadingMore = false;


  bool downloadLoading = false;

  Future<void> downloadList({required bool isPdf, bool? shouldPrint}) async {
    if(downloadLoading){
      return;
    }
    downloadLoading = true;

    hasError.value = false;

    String fileName = "Profit or Loss of ${loginData!.business.name} -${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await ProfitOrLossService.downloadList(
        isPdf: isPdf,
        usrToken: loginData!.token,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
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
        profitOrLossList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      profitOrLossList.clear();
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