import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/book_ledger/book_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';
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

class LedgerController extends GetxController{

  bool ledgerListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  TextEditingController searchController = TextEditingController();

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  // List<MoneyAdjustmentData> ledgerList = [];
  // MoneyAdjustmentListResponseModel? MoneyAdjustmentListResponseModel;

  List<LedgerData> ledgerList = [];
  BookLedgerListResponseModel? bookLedgerListResponseModel;




  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  onInit(){
    super.onInit();
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
      {int page = 1, required int caID}) async {
    ledgerListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      ledgerList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','ledger_list']);

    try {
      var response = await BookLedgerService.getBookLedger(
        usrToken: loginData!.token,
        page: page,
        caID: caID,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      if (response != null) {
        logger.e(response);
        bookLedgerListResponseModel =
            BookLedgerListResponseModel.fromJson(response);
        logger.i(bookLedgerListResponseModel?.data?.first.debit);

        if (bookLedgerListResponseModel != null && bookLedgerListResponseModel!.data != null && bookLedgerListResponseModel!.data!.first.data != null) {
          ledgerList.addAll(bookLedgerListResponseModel!.data!.first.data!.data);
          logger.i(ledgerList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          ledgerList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        ledgerList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      ledgerList.clear();
      logger.e(e);
    } finally {
      ledgerListLoading = false;
      isLoadingMore = false;
      update(['total_widget','ledger_list']);
    }
  }


  bool isAddOrUpdateLoading = false;


  //Client Ledger

  bool isClientLedgerListLoading = false;
  bool isClientLedgerListLoadingMore = false;


  bool downloadLoading = false;

  Future<void> downloadList({required ChartOfAccountPaymentMethod? ca,required bool isPdf, bool? shouldPrint}) async {
    if(downloadLoading){
      return;
    }
    downloadLoading = true;
    if(ca == null){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "Please select an account first");
      return;
    }
    hasError.value = false;

    String fileName = "Book Ledger of ${ca.name}-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await BookLedgerService.downloadList(
        isPdf: isPdf,
        usrToken: loginData!.token,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        fileName: fileName,
        shouldPrint: shouldPrint,
        caID: ca.id,
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
        ledgerList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      ledgerList.clear();
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