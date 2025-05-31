import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/features/accounting/data/models/cash_statement/cash_statement_report_list_reponse_model.dart';
import 'package:amar_pos/features/accounting/data/services/cash_statement_report_service.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_transfer/money_transfer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/network/helpers/error_extractor.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';

class CashStatementController extends GetxController{
  LoginData? loginData = LoginDataBoxManager().loginData;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  TextEditingController searchController = TextEditingController();
  var hasError = false.obs;
  final MoneyTransferController moneyTransferController = Get.put(MoneyTransferController());


  bool isAccountLoading = false;
  Future<void> getAccounts() async{

    update(['account']);
    logger.e(loginData!.businessOwner);
    if(loginData!.businessOwner){
      await moneyTransferController.getAllPaymentMethods();
    }else{
      await moneyTransferController.getOutletForMoneyTransferList();
    }
    update(['account']);
  }



  bool isCashStatementReportLoading = false;
  bool isLoadingMore = false;


  CashStatementReportListResponseModel? cashStatementEntryListResponseModel;
  List<CashStatementEntry> cashStatementEntryList = [];


  Future<void> getCashStatementEntryList(
      {int page = 1,String? search, required int caId}) async {
    isCashStatementReportLoading = page == 1; // Mark initial loading state
    if(page == 1){
      cashStatementEntryList.clear();
    }
    isLoadingMore = page > 1;

    logger.d("---->");
    hasError.value = false;
    update(['total_widget','cash_statement_report_list']);

    try {
      var response = await CashStatementReportService.getCashStatementReportList(
        usrToken: loginData!.token,
        page: page,
        search: search,
        caId: caId,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      if (response != null) {
        logger.i(response);
        cashStatementEntryListResponseModel =
            CashStatementReportListResponseModel.fromJson(response);

        if (cashStatementEntryListResponseModel != null && cashStatementEntryListResponseModel!.data.isNotEmpty) {
          cashStatementEntryList.addAll(cashStatementEntryListResponseModel!.data.first.data.data);
          logger.i(cashStatementEntryList.length);
        } else {
          cashStatementEntryList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        cashStatementEntryList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      cashStatementEntryList.clear();
      logger.e(e);
    } finally {
      isCashStatementReportLoading = false;
      isLoadingMore = false;
      update(['total_widget','cash_statement_report_list']);
    }
  }

  Future<void> downloadList({required bool isPdf, bool? shouldPrint, required int caId}) async {
    bool hasPermission = true;

    // hasPermission = checkStockTransferPermissions(isPdf ? "exportToPdfTransferList": "exportToExcelTransferList");

    // if(!hasPermission) return;

    if(cashStatementEntryList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be ${shouldPrint != null? "printed": "downloaded"} with empty data.");
      return;
    }
    hasError.value = false;

    String fileName = "Cash statement -${
        selectedDateTimeRange.value != null ? "${selectedDateTimeRange.value!.start.toIso8601String().split("T")[0]}-${selectedDateTimeRange.value!.end.toIso8601String().split("T")[0]}": DateTime.now().toIso8601String().split("T")[0]
            .toString()
    }${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await CashStatementReportService.downloadList(
        usrToken: loginData!.token,
        isPdf: isPdf,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        fileName: fileName,
        caId: caId,
        shouldPrint: shouldPrint,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }
}