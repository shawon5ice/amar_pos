import 'package:amar_pos/features/accounting/data/models/daily_statement/daily_statement_report_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/daily_statement_service.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';

class DailyStatementController extends GetxController{

  bool isStatementListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  List<TransactionData> dailyStatementList = [];
  List<TransactionData> currentSearchList = [];
  DailyStatementReportResponseModel? dailyStatementReportResponseModel;


  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  onInit(){
    super.onInit();
    getDailyStatement(page: 1);
  }

  Future<void> getDailyStatement(
      { String? search, required int page}) async {
    isStatementListLoading = page == 1; // Mark initial loading state
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_statement_history','daily_statement_list']);

    try {
      var response = await DailyStatementService.getDailyStatement(
        usrToken: loginData!.token,
        page: page,
        search: search,
      );

      if (response != null && response['success']) {
        logger.e(response);
        dailyStatementReportResponseModel =
            DailyStatementReportResponseModel.fromJson(response);

        if (dailyStatementReportResponseModel != null) {
          dailyStatementList = dailyStatementReportResponseModel!.data.first.data.data;
          logger.i(dailyStatementList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          currentSearchList.clear(); // No results
        }
      } else {
        hasError.value = true; // Error in response
        currentSearchList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      currentSearchList.clear();
      logger.e(e);
    } finally {
      isStatementListLoading = false;
      isLoadingMore = false;
      update(['total_statement_history','daily_statement_list']);
    }
  }
}