import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/balance_sheet/balance_sheet_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/book_ledger/book_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/trial_balance/trial_balance_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/balance_sheet_service.dart';
import 'package:amar_pos/features/accounting/data/services/book_ledger_service.dart';
import 'package:amar_pos/features/accounting/data/services/chart_of_account_list.dart';
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
import '../../../data/models/chart_of_account/chart_of_account_list_response_model.dart';
import '../../../data/models/profit_or_loss/profit_or_loss_list_response_model.dart';
import '../../../data/services/trial_balance_service.dart';

class ChartOfAccountController extends GetxController{

  bool profitOrLossListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  TextEditingController searchController = TextEditingController();

  int? selectedOutletId;
  Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);


  List<BalanceSheet> balanceSheetList = [];
  BalanceSheetListResponseModel? balanceSheetListResponseModel;




  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  void onReady() {
    super.onReady();
    getChartOfAccountList();
  }


  void setSelectedDateRange(DateTime? range) {
    selectedDateTime.value = range;
    update(['selection_status']);
  }

  bool isChartOfAccountListLoading = false;
  ChartOfAccountListResponseModel? chartOfAccountListResponseModel;
  List<ChartOfAccountItem> chartOfAccountList = [];

  Future<void> getChartOfAccountList(
      {int page = 1,}) async {
    isChartOfAccountListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      chartOfAccountList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','chart_of_account_list']);

    try {
      var response = await ChartOfAccountService.getChartOfAccountList(
        usrToken: loginData!.token,
        page: page,
        search: searchController.text,
        endDate: selectedDateTime.value?.toString(),
      );

      if (response != null) {
        logger.i(response);
        chartOfAccountListResponseModel =
            ChartOfAccountListResponseModel.fromJson(response);

        if (chartOfAccountListResponseModel != null && chartOfAccountListResponseModel!.data.data.isNotEmpty) {
          chartOfAccountList.addAll(chartOfAccountListResponseModel!.data.data);
          logger.i(chartOfAccountList.length);
        } else {
          chartOfAccountList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        chartOfAccountList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      chartOfAccountList.clear();
      logger.e(e);
    } finally {
      isChartOfAccountListLoading = false;
      isLoadingMore = false;
      update(['total_widget','chart_of_account_list']);
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

    String fileName = "Balance sheet of ${loginData!.business.name} -${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await BalanceSheetService.downloadList(
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
}