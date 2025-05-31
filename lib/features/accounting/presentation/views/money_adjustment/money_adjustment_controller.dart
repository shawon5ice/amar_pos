import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_adjustment_list_response_model/money_adjustment_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/due_collection_service.dart';
import 'package:amar_pos/features/accounting/data/services/money_transfer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/core.dart';
import '../../../../../core/network/base_client.dart';
import '../../../../../core/network/helpers/error_extractor.dart';
import '../../../../../core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';
import '../../../data/models/expense_voucher/expense_categories_response_model.dart';
import '../../../data/services/money_adjustment_service.dart';

class MoneyAdjustmentController extends GetxController{

  bool isMoneyAdjustmentListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  TextEditingController searchController = TextEditingController();

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  // List<MoneyAdjustmentData> moneyAdjustmentList = [];
  // MoneyAdjustmentListResponseModel? MoneyAdjustmentListResponseModel;

  List<MoneyAdjustmentData> moneyAdjustmentList = [];
  MoneyAdjustmentListResponseModel? moneyAdjustmentListResponseModel;

  ExpenseCategoriesResponseModel? expenseCategoriesResponseModel;
  List<ExpenseCategory> expenseCategoriesList = [];

  ExpensePaymentMethodsResponseModel? expensePaymentMethodsResponseModel;
  List<ExpensePaymentMethod> expensePaymentMethods = [];


  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  onInit(){
    super.onInit();
  }


  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }

  void clearFilter(){
    searchController.clear();
    selectedDateTimeRange.value = null;
  }

  int adjustmentType = 1;

  Future<void> getMoneyAdjustmentList(
      {int page = 1, int? type}) async {
    adjustmentType = type ?? adjustmentType;
    isMoneyAdjustmentListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      moneyAdjustmentList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','money_adjustment_list$adjustmentType']);

    try {
      var response = await MoneyAdjustmentService.getMoneyAdjustmentList(
        usrToken: loginData!.token,
        page: page,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
        moneyAdjustmentType: adjustmentType
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        moneyAdjustmentListResponseModel =
            MoneyAdjustmentListResponseModel.fromJson(response);

        if (moneyAdjustmentListResponseModel != null && moneyAdjustmentListResponseModel!.data != null) {
          moneyAdjustmentList.addAll(moneyAdjustmentListResponseModel!.data!.data!);
          logger.i(moneyAdjustmentList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          moneyAdjustmentList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        moneyAdjustmentList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      moneyAdjustmentList.clear();
      logger.e(e);
    } finally {
      isMoneyAdjustmentListLoading = false;
      isLoadingMore = false;
      update(['total_widget','money_adjustment_list$adjustmentType']);
    }
  }


  bool isAddOrUpdateLoading = false;

  void storeNewMoneyAdjustment({
    required int caID,
    required num amount,
    String? remarks,
  }) async {
    isAddOrUpdateLoading = true;
    update(["money_adjustment_list$adjustmentType"]);
    RandomLottieLoader.show();
    try{
      var response = await MoneyAdjustmentService.storeNewMoneyAdjustment(
        token: loginData!.token,
        caID: caID,
        amount: amount,
        remarks: remarks,
        type: adjustmentType
      );
      if (response != null) {

        if(response['success']){
          getMoneyAdjustmentList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddOrUpdateLoading = false;
      update(['money_adjustment_list$adjustmentType']);
    }
    update(["money_adjustment_list$adjustmentType"]);
    RandomLottieLoader.hide();
  }

  void updateMoneyAdjustmentItem({
    required int id,
    required int caID,
    required num amount,
    String? remarks,
  }) async {
    isAddOrUpdateLoading = true;
    update(["money_adjustment_list$adjustmentType"]);
    RandomLottieLoader.show();
    try{
      var response = await MoneyAdjustmentService.updateMoneyAdjustmentItem(
        id: id,
        token: loginData!.token,
        amount: amount,
        remarks: remarks,
        caID: caID,
        type: adjustmentType
      );
      if (response != null) {

        if(response['success']){
          moneyAdjustmentList.clear();
          getMoneyAdjustmentList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddOrUpdateLoading = false;
      update(['money_adjustment_list$adjustmentType']);
    }
    update(["money_adjustment_list$adjustmentType"]);
    RandomLottieLoader.hide();
  }

  void deleteMoneyAdjustmentItem({
    required int id,
  }) async {
    isAddOrUpdateLoading = true;
    update(["money_adjustment_list$adjustmentType"]);
    RandomLottieLoader.show();
    try{
      var response = await MoneyAdjustmentService.deleteMoneyAdjustmentItem(
        id: id,
        token: loginData!.token,
      );
      if (response != null) {

        if(response['success']){
          moneyAdjustmentList.clear();
          getMoneyAdjustmentList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddOrUpdateLoading = false;
      update(['money_adjustment_list$adjustmentType']);
    }
    update(["money_adjustment_list$adjustmentType"]);
    RandomLottieLoader.hide();
  }

  Future<void> downloadList({required bool isPdf, bool? shouldPrint, required int type}) async {
    hasError.value = false;

    if(moneyAdjustmentList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be downloaded with empty data");
      return;
    }

    String fileName = "Money ${type == 1 ? "Add":"Withdraw"} List-${loginData?.business.name}-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await MoneyAdjustmentService.downloadList(
        isPdf: isPdf,
        usrToken: loginData!.token,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        fileName: fileName,
        shouldPrint: shouldPrint,
        type: type,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }


  Future<void> downloadStatement({required bool isPdf, required int clientID}) async {
    hasError.value = false;

    String fileName = "Due Statement'-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await DueCollectionService.downloadStatement(
        isPdf: isPdf,
        usrToken: loginData!.token,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        fileName: fileName,
        clientID: clientID,
      );
    } catch (e) {
      logger.e(e);
    } finally {

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
        moneyAdjustmentList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      moneyAdjustmentList.clear();
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