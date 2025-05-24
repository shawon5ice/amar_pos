import 'package:amar_pos/features/accounting/data/models/daily_statement/daily_statement_report_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/daily_statement_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/network/helpers/error_extractor.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';

class DailyStatementController extends GetxController{

  bool isStatementListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  List<DailyStatementItem> dailyStatementList = [];
  List<DailyStatementItem> currentSearchList = [];
  DailyStatementReportResponseModel? dailyStatementReportResponseModel;


  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  onInit(){
    super.onInit();
    selectedDateTimeRange.value = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    getDailyStatement(page: 1);
  }


  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }


  Future<void> getDailyStatement(
      { String? search, int page = 1,int? caId,}) async {
    isStatementListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      dailyStatementList.clear();
    }
    isLoadingMore = page > 1;

    selectedOutletId = caId;

    hasError.value = false;
    update(['total_statement_history','daily_statement_list']);

    try {
      var response = await DailyStatementService.getDailyStatement(
        usrToken: loginData!.token,
        page: page,
        search: search,
        caId: caId,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      if (response != null && response['success']) {
        logger.e(response);
        dailyStatementReportResponseModel =
            DailyStatementReportResponseModel.fromJson(response);

        if (dailyStatementReportResponseModel != null) {
          dailyStatementList.addAll(dailyStatementReportResponseModel!.data.data);
          logger.i(dailyStatementList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          currentSearchList.clear(); // No results
        }
      }
    } catch (e) {
      if(page>1){
        hasError.value = true; // Handle exceptions
        currentSearchList.clear();
      }
      logger.e(e);
    } finally {
      isStatementListLoading = false;
      isLoadingMore = false;
      update(['total_statement_history','daily_statement_list']);
    }
  }

  Future<void> downloadDailyStatement({required bool isPdf,bool? shouldPrint}) async {
    hasError.value = false;
    if(dailyStatementList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be ${shouldPrint != null ? 'printed': 'downloaded'} with empty data");
      return;
    }

    String fileName = "Daily statement-${
        selectedDateTimeRange.value != null ? "${selectedDateTimeRange.value!.start.toIso8601String().split("T")[0]}-${selectedDateTimeRange.value!.end.toIso8601String().split("T")[0]}": DateTime.now().toIso8601String().split("T")[0]
            .toString()
    }${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await DailyStatementService.downloadList(
        usrToken: loginData!.token,
        isPdf: isPdf,
        // search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        caId: selectedOutletId,
        fileName: fileName,
        shouldPrint: shouldPrint
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }
}