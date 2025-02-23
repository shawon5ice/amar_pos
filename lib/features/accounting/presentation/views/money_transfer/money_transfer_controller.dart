import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/money_transfer_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';
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

class MoneyTransferController extends GetxController{

  bool ismoneyTransferListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  TextEditingController searchController = TextEditingController();

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  // List<MoneyAdjustmentData> moneyTransferList = [];
  // MoneyAdjustmentListResponseModel? MoneyAdjustmentListResponseModel;

  List<MoneyTransferData> moneyTransferList = [];
  MoneyTransferListResponseModel? moneyTransferListResponseModel;



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

  Future<void> getMoneyTransferList(
      {int page = 1}) async {
    ismoneyTransferListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      moneyTransferList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','money_transfer_list']);

    try {
      var response = await MoneyTransferService.getMoneyTransferList(
        usrToken: loginData!.token,
        page: page,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        moneyTransferListResponseModel =
            MoneyTransferListResponseModel.fromJson(response);

        if (moneyTransferListResponseModel != null && moneyTransferListResponseModel!.data != null) {
          moneyTransferList.addAll(moneyTransferListResponseModel!.data!.data!);
          logger.i(moneyTransferList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          moneyTransferList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        moneyTransferList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      moneyTransferList.clear();
      logger.e(e);
    } finally {
      ismoneyTransferListLoading = false;
      isLoadingMore = false;
      update(['total_widget','money_transfer_list']);
    }
  }


  bool isAddOrUpdateLoading = false;

  void storeNewMoneyTransfer({
    required int fromStoreID,
    required int fromAccountID,
    required int toAccountID,
    required int toStoreID,
    required num amount,
    String? remarks,
  }) async {
    isAddOrUpdateLoading = true;
    update(["money_transfer_list"]);
    RandomLottieLoader.show();
    try{
      var response = await MoneyTransferService.storeNewMoneyTransfer(
        token: loginData!.token,
        fromAccountID: fromAccountID,
        fromStoreID: fromStoreID,
        toAccountID: toAccountID,
        toStoreID: toStoreID,
        amount: amount,
        remarks: remarks,
      );
      if (response != null) {

        if(response['success']){
          getMoneyTransferList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddOrUpdateLoading = false;
      update(['money_transfer_list']);
    }
    update(["money_transfer_list"]);
    RandomLottieLoader.hide();
  }

  void updateMoneyTransferItem({
    required int id,
    required int fromStoreID,
    required int fromAccountID,
    required int toAccountID,
    required int toStoreID,
    required num amount,
    String? remarks,
  }) async {
    isAddOrUpdateLoading = true;
    update(["money_transfer_list"]);
    RandomLottieLoader.show();
    try{
      var response = await MoneyTransferService.updateMoneyTransfer(
        id: id,
        token: loginData!.token,
        fromAccountID: fromAccountID,
        fromStoreID: fromStoreID,
        toAccountID: toAccountID,
        toStoreID: toStoreID,
        amount: amount,
        remarks: remarks,
      );
      if (response != null) {

        if(response['success']){
          moneyTransferList.clear();
          getMoneyTransferList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddOrUpdateLoading = false;
      update(['money_transfer_list']);
    }
    update(["money_transfer_list"]);
    RandomLottieLoader.hide();
  }

  void deleteMoneyTransferItem({
    required int id,
  }) async {
    isAddOrUpdateLoading = true;
    update(["money_transfer_list"]);
    RandomLottieLoader.show();
    try{
      var response = await MoneyTransferService.deleteMoneyTransferItem(
        id: id,
        token: loginData!.token,
      );
      if (response != null) {

        if(response['success']){
          moneyTransferList.clear();
          getMoneyTransferList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddOrUpdateLoading = false;
      update(['money_transfer_list']);
    }
    update(["money_transfer_list"]);
    RandomLottieLoader.hide();
  }


  //Client Ledger

  bool isClientLedgerListLoading = false;
  bool isClientLedgerListLoadingMore = false;



  Future<void> downloadList({required bool isPdf, bool? shouldPrint}) async {
    hasError.value = false;

    String fileName = "Money Adjustment-${loginData?.business.name}-${DateTime
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
        moneyTransferList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      moneyTransferList.clear();
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