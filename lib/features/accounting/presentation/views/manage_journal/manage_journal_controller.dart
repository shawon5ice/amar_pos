import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/features/accounting/data/models/balance_sheet/balance_sheet_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/chart_of_account/chart_of_account_opening_history_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/chart_of_account/last_level_chart_of_account_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/balance_sheet_service.dart';
import 'package:amar_pos/features/accounting/data/services/chart_of_account_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/network/helpers/error_extractor.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';
import '../../../data/models/chart_of_account/chart_of_account_list_response_model.dart';

class ManageJournalController extends GetxController{

  bool profitOrLossListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  TextEditingController searchController = TextEditingController();

  int? selectedOutletId;
  Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);


  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);


  List<BalanceSheet> balanceSheetList = [];
  BalanceSheetListResponseModel? balanceSheetListResponseModel;




  LoginData? loginData = LoginDataBoxManager().loginData;


  void setSelectedDateRange(DateTime? range) {
    selectedDateTime.value = range;
    update(['selection_status']);
  }

  bool isChartOfAccountListLoading = false;
  ChartOfAccountListResponseModel? chartOfAccountListResponseModel;
  List<ChartOfAccountItem> chartOfAccountList = [];

  Future<void> getChartOfAccountList(
      {int page = 1,String? search}) async {
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
        search: search,
        endDate: selectedDateTime.value?.toString(),
      );

      if (response != null) {
        logger.i(response);
        chartOfAccountListResponseModel =
            ChartOfAccountListResponseModel.fromJson(response);

        if (chartOfAccountListResponseModel != null && chartOfAccountListResponseModel!.data.data.isNotEmpty) {
          chartOfAccountList = chartOfAccountListResponseModel!.data.data;
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


  bool isChartOfAccountOpeningHistoryListLoading = false;
  ChartOfAccountOpeningHistoryListResponseModel? chartOfAccountOpeningHistoryListResponseModel;
  List<ChartOfAccountOpeningEntry> chartOfAccountOpeningEntryList = [];

  Future<void> getChartOfAccountOpeningHistoryList(
      {int page = 1,String? search}) async {
    isChartOfAccountOpeningHistoryListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      chartOfAccountOpeningEntryList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','chart_of_account_opening_history_list']);

    try {
      var response = await ChartOfAccountService.getChartOfAccountOpeningHistoryList(
        usrToken: loginData!.token,
        page: page,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      if (response != null) {
        logger.i(response);
        chartOfAccountOpeningHistoryListResponseModel =
            ChartOfAccountOpeningHistoryListResponseModel.fromJson(response);

        if (chartOfAccountOpeningHistoryListResponseModel != null && chartOfAccountOpeningHistoryListResponseModel!.data != null) {
          chartOfAccountOpeningEntryList.addAll(chartOfAccountOpeningHistoryListResponseModel!.data!.data);
          logger.i(chartOfAccountOpeningEntryList.length);
        } else {
          chartOfAccountOpeningEntryList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        chartOfAccountOpeningEntryList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      chartOfAccountOpeningEntryList.clear();
      logger.e(e);
    } finally {
      isChartOfAccountOpeningHistoryListLoading = false;
      isLoadingMore = false;
      update(['total_widget','chart_of_account_opening_history_list']);
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
    if(chartOfAccountOpeningEntryList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be ${shouldPrint != null? "printed": "downloaded"} with empty data.");
      return;
    }
    downloadLoading = true;

    hasError.value = false;

    String fileName = "Chart of account opening list -${formatDate(DateTime.now())}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await ChartOfAccountService.downloadList(
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

  bool isLastLevelChartOfAccounts = false;
  LastLevelChartOfAccountListResponseModel? lastLevelChartOfAccountListResponseModel;
  List<ChartOfAccount> lastLevelChartOfAccountList = [];

  Future<void> getLastLevelChartOfAccounts() async {
    isLastLevelChartOfAccounts = true;
    hasError.value = false;
    update(['last_level_chart_of_account_list']);

    try {
      var response = await ChartOfAccountService.getLastLevelChartOfAccounts(
        usrToken: loginData!.token,
      );

      if (response != null) {
        logger.i(response);
        lastLevelChartOfAccountListResponseModel =
            LastLevelChartOfAccountListResponseModel.fromJson(response);

        if (lastLevelChartOfAccountListResponseModel != null && lastLevelChartOfAccountListResponseModel!.data.isNotEmpty) {
          lastLevelChartOfAccountList = lastLevelChartOfAccountListResponseModel!.data;
          logger.i(lastLevelChartOfAccountList.length);
        } else {
          lastLevelChartOfAccountList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        lastLevelChartOfAccountList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      lastLevelChartOfAccountList.clear();
      logger.e(e);
    } finally {
      isLastLevelChartOfAccounts = false;
      update(['last_level_chart_of_account_list']);
    }
  }

  bool isCreationOfAccountHistoryOngoing = false;
  Future<void> createAccountHistory(var request) async {
    isCreationOfAccountHistoryOngoing = true;
    update(['account_entry_form']);
    try {
      var response = await ChartOfAccountService.createAccountOpeningHistory(
        usrToken: loginData!.token,
        data: request,
      );

      if (response != null) {
        logger.i(response);
        if(response['success']){
          getChartOfAccountOpeningHistoryList();
          Get.back();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true : null);
      } else {
        Methods.showSnackbar(msg: "Something went wrong!");
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isCreationOfAccountHistoryOngoing = false;
      update(['account_entry_form']);
    }
  }

  Future<void> updateAccountHistory(var request, int id) async {
    isCreationOfAccountHistoryOngoing = true;
    update(['account_entry_form']);
    try {
      var response = await ChartOfAccountService.updateAccountOpeningHistory(
        usrToken: loginData!.token,
        data: request,
        id: id,
      );

      if (response != null) {
        logger.i(response);
        if(response['success']){
          getChartOfAccountOpeningHistoryList();
          Get.back();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true : null);
      } else {
        Methods.showSnackbar(msg: "Something went wrong!");
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isCreationOfAccountHistoryOngoing = false;
      update(['account_entry_form']);
    }
  }

  Future<void> deleteAccountHistory(int id) async {
    isCreationOfAccountHistoryOngoing = true;
    update(['account_entry_form']);
    try {
      var response = await ChartOfAccountService.deleteAccountOpeningHistory(
        usrToken: loginData!.token,
        id: id,
      );

      if (response != null) {
        logger.i(response);
        if(response['success']){
          getChartOfAccountOpeningHistoryList();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true : null);
      } else {
        Methods.showSnackbar(msg: "Something went wrong!");
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isCreationOfAccountHistoryOngoing = false;
      update(['account_entry_form']);
    }
  }

  Future<void> downloadAccountOpeningHistory({required int id,required String slNo, bool? shouldPrint}) async {
    if(downloadLoading){
      return;
    }
    downloadLoading = true;

    hasError.value = false;

    String fileName = "$slNo.pdf";

    try {
      var response = await ChartOfAccountService.downloadAccountOpeningHistory(
        usrToken: loginData!.token,
        fileName: fileName,
        shouldPrint: shouldPrint,
        id: id,
      );
    } catch (e) {
      logger.e(e);
    } finally {
      downloadLoading = false;
    }
  }
}