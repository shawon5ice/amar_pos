import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_statement_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/due_collection/due_collection_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_voucher_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_ledger/supplier_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_ledger/supplier_ledger_statement_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_payment/supplier_payment_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/due_collection_service.dart';
import 'package:amar_pos/features/accounting/data/services/expense_voucher_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/core.dart';
import '../../../../../core/network/helpers/error_extractor.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';
import '../../../data/models/expense_voucher/expense_categories_response_model.dart';
import '../../../data/models/expense_voucher/expense_voucher_response_model.dart';
import '../../../data/services/supplier_payment_service.dart';

class SupplierPaymentController extends GetxController{

  bool isSupplierPaymentListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  TextEditingController searchController = TextEditingController();

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  List<SupplierPaymentData> supplierPaymentList = [];
  SupplierPaymentListResponseModel? supplierPaymentListResponseModel;

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

  Future<void> getSupplierPaymentList(
      {int page = 1}) async {
    isSupplierPaymentListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      supplierPaymentList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','supplier_payment_list']);

    try {
      var response = await SupplierPaymentService.getSupplierPaymentList(
        usrToken: loginData!.token,
        page: page,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        supplierPaymentListResponseModel =
            SupplierPaymentListResponseModel.fromJson(response);

        if (supplierPaymentListResponseModel != null && supplierPaymentListResponseModel!.data != null) {
          supplierPaymentList.addAll(supplierPaymentListResponseModel!.data!.data!);
          logger.i(supplierPaymentList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          supplierPaymentList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        supplierPaymentList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      supplierPaymentList.clear();
      logger.e(e);
    } finally {
      isSupplierPaymentListLoading = false;
      isLoadingMore = false;
      update(['total_widget','supplier_payment_list']);
    }
  }

  Future<void> getExpenseCategories({int page = 1, int limit = 20}) async {
    if(page == 1){
      isExpenseCategoriesListLoading = true;
      expenseCategoriesList.clear();
    }else{
      isLoadingMore = true;
    }

    hasError.value = false;
    update(['expense_vouchers_categories_list','expense_category_dd']);

    try {
      var response = await ExpenseVoucherService.getExpenseCategories(
        usrToken: loginData!.token,
        page: page,
        limit: limit,
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        expenseCategoriesResponseModel =
            ExpenseCategoriesResponseModel.fromJson(response);

        if (expenseCategoriesResponseModel != null) {
          expenseCategoriesList.addAll(expenseCategoriesResponseModel!.data.data!);
          logger.i(expenseCategoriesList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          // currentSearchList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        // currentSearchList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      // currentSearchList.clear();
      logger.e(e);
    } finally {
      isExpenseCategoriesListLoading = false;
      isLoadingMore = false;
      update(['expense_vouchers_categories_list','expense_category_dd']);
    }
  }


  bool isAddCategoryLoading = false;
  
  void addNewCategory({
    required String categoryName,
  }) async {
    isAddCategoryLoading = true;
    update(["expense_vouchers_categories_list"]);
    RandomLottieLoader.show();
    try{
      var response = await ExpenseVoucherService.storeCategory(
        token: loginData!.token,
        categoryName: categoryName,
      );
      if (response != null) {

        if(response['success']){
          getExpenseCategories();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['expense_vouchers_categories_list']);
    }
    update(["expense_vouchers_categories_list"]);
    RandomLottieLoader.hide();
  }


  void addNewSupplierPayment({
    required int clientID,
    required int caID,
    required num amount,
    String? remarks,
  }) async {
    isAddCategoryLoading = true;
    update(["supplier_payment_list"]);
    RandomLottieLoader.show();
    try{
      var response = await SupplierPaymentService.addNewSupplierPayment(
        token: loginData!.token,
        caID: caID,
        supplierID: clientID,
        amount: amount,
        remarks: remarks,
      );
      if (response != null) {

        if(response['success']){
          getSupplierPaymentList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['supplier_payment_list']);
    }
    update(["supplier_payment_list"]);
    RandomLottieLoader.hide();
  }

  void updateSupplierPayment({
    required int id,
    required int supplierID,
    required int caID,
    required num amount,
    String? remarks,
  }) async {
    isAddCategoryLoading = true;
    update(["supplier_payment_list"]);
    RandomLottieLoader.show();
    try{
      var response = await SupplierPaymentService.updateSupplierPayment(
        id: id,
        token: loginData!.token,
        caID: caID,
        supplierID: supplierID,
        amount: amount,
        remarks: remarks,
      );
      if (response != null) {

        if(response['success']){
          getSupplierPaymentList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['supplier_payment_list']);
    }
    update(["supplier_payment_list"]);
    RandomLottieLoader.hide();
  }

  void deleteSupplierPayment({
    required SupplierPaymentData transaction,
  }) async {
    isAddCategoryLoading = true;
    update(["supplier_payment_list"]);
    RandomLottieLoader.show();
    try{
      var response = await SupplierPaymentService.deleteSupplierPayment(
        id: transaction.id,
        token: loginData!.token,
      );
      if (response != null) {

        if(response['success']){
          getSupplierPaymentList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['supplier_payment_list']);
    }
    update(["supplier_payment_list"]);
    RandomLottieLoader.hide();
  }


  //Client Ledger

  bool isSupplierLedgerListLoading = false;
  bool isSupplierLedgerListLoadingMore = false;

  SupplierLedgerListResponseModel? supplierLedgerListResponseModel;
  List<SupplierLedgerData> supplierLedgerList = [];

  Future<void> getSupplierLedger({int page = 1}) async {
    isSupplierLedgerListLoading = page == 1;
    if(page == 1){
      supplierLedgerList.clear();
    }
    isSupplierLedgerListLoadingMore = page > 1;

    hasError.value = false;
    update(['supplier_ledger_total_widget','supplier_ledger']);

    try {
      var response = await SupplierPaymentService.getSupplierLedgerList(
        usrToken: loginData!.token,
        page: page,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        supplierLedgerListResponseModel =
            SupplierLedgerListResponseModel.fromJson(response);

        if (supplierLedgerListResponseModel != null && supplierLedgerListResponseModel!.data != null) {
          supplierLedgerList.addAll(supplierLedgerListResponseModel!.data!.data!);
          logger.i(supplierLedgerList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          supplierLedgerList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        supplierLedgerList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      supplierLedgerList.clear();
      logger.e(e);
    } finally {
      isSupplierLedgerListLoading = false;
      isSupplierLedgerListLoadingMore = false;
      update(['supplier_ledger_total_widget','supplier_ledger']);
    }
  }


  //Client ledger statement
  bool isSupplierLedgerStatementListLoading = false;
  bool isSupplierLedgerStatementListLoadingMore = false;

  SupplierLedgerStatementResponseModel? supplierLedgerStatementResponseModel;

  Future<void> getSupplierLedgerStatement({required int id}) async {
    isSupplierLedgerStatementListLoading = true;
    // if(page == 1){
    //   supplierPaymentList.clear();
    // }
    // isSupplierLedgerStatementListLoadingMore = page > 1;

    hasError.value = false;
    update(['supplier_ledger_statement']);

    try {
      var response = await SupplierPaymentService.getSupplierLedgerStatementList(
        usrToken: loginData!.token,
        id: id,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        supplierLedgerStatementResponseModel =
            SupplierLedgerStatementResponseModel.fromJson(response);
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isSupplierLedgerStatementListLoading = false;
      isSupplierLedgerStatementListLoadingMore = false;
      update(['supplier_ledger_statement']);
    }
  }

  Future<void> downloadList({required bool isPdf, required bool supplierLedger, bool? shouldPrint}) async {
    hasError.value = false;

    if((supplierLedger && supplierLedgerList.isEmpty)|| !supplierLedger && supplierPaymentList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be downloaded with empty data");
      return;
    }

    String fileName = "${supplierLedger ? 'Supplier Payment Ledger': 'Supplier Payment'}-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await SupplierPaymentService.downloadList(
        supplierLedger: supplierLedger,
        isPdf: isPdf,
        usrToken: loginData!.token,
        search: searchController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        fileName: fileName,
        shouldPrint: shouldPrint
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }


  Future<void> downloadStatement({required bool isPdf, required int clientID, bool? shouldPrint}) async {
    hasError.value = false;

    String fileName = "Supplier Payment Statement'-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await SupplierPaymentService.downloadStatement(
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


  bool detailsLoading = false;

  Future<void> getSupplierPaymentDetail(int orderId) async {
    detailsLoading = true;
    saleHistoryDetailsResponseModel = null;
    update(['sold_history_details','download_print_buttons']);
    try {
      var response = await SupplierPaymentService.getSupplierPaymentDetail(
        usrToken: loginData!.token,
        id: orderId,
      );

      logger.i(response);
      if (response != null) {
        saleHistoryDetailsResponseModel =
            ReturnHistoryDetailsResponseModel.fromJson(response);
      }
    } catch (e) {
    } finally {
      detailsLoading = false;
      update(['sold_history_details','download_print_buttons']);
    }
  }
}