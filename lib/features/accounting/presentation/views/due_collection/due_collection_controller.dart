import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_statement_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/due_collection/due_collection_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_voucher_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/due_collection_service.dart';
import 'package:amar_pos/features/accounting/data/services/expense_voucher_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/core.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';
import '../../../data/models/expense_voucher/expense_categories_response_model.dart';
import '../../../data/models/expense_voucher/expense_voucher_response_model.dart';

class DueCollectionController extends GetxController{

  bool isDueCollectionListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  List<DueCollectionData> dueCollectionList = [];
  DueCollectionListResponseModel? dueCollectionListResponseModel;

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


  Future<void> getDueCollectionList(
      { String? search, int page = 1}) async {
    isDueCollectionListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      dueCollectionList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_widget','collection_list']);

    try {
      var response = await DueCollectionService.getDueCollectionList(
        usrToken: loginData!.token,
        page: page,
        search: search,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        dueCollectionListResponseModel =
            DueCollectionListResponseModel.fromJson(response);

        if (dueCollectionListResponseModel != null && dueCollectionListResponseModel!.data != null) {
          dueCollectionList.addAll(dueCollectionListResponseModel!.data!.data!);
          logger.i(dueCollectionList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          dueCollectionList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        dueCollectionList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      dueCollectionList.clear();
      logger.e(e);
    } finally {
      isDueCollectionListLoading = false;
      isLoadingMore = false;
      update(['total_widget','collection_list']);
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

  // void editCategory({
  //   required Category category,
  //   required String categoryName,
  // }) async {
  //   isAddCategoryLoading = true;
  //   update(["expense_vouchers_categories_list"]);
  //   EasyLoading.show();
  //   try{
  //     var response = await ExpenseVoucherService.update(
  //       token: loginData!.token,
  //       categoryName: categoryName,
  //       brandId: category.id,
  //     );
  //     if (response != null) {
  //
  //       if(response['success']){
  //         getAllCategory();
  //       }
  //       Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
  //     }
  //   }catch(e){
  //     logger.e(e);
  //   }finally{
  //     categoryListLoading = false;
  //     update(['expense_vouchers_categories_list']);
  //   }
  //   update(["expense_vouchers_categories_list"]);
  //   EasyLoading.dismiss();
  // }
  //
  // void deleteCategory({
  //   required Category category,
  // }) async {
  //   isAddCategoryLoading = true;
  //   update(["expense_vouchers_categories_list"]);
  //   EasyLoading.show();
  //   try{
  //     var response = await CategoryService.delete(
  //       token: loginData!.token,
  //       categoryId: category.id,
  //     );
  //     if (response != null) {
  //
  //       if(response['success']){
  //         categoryList.remove(category);
  //         allCategoryCopy.remove(category);
  //       }
  //       Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
  //     }
  //   }catch(e){
  //     logger.e(e);
  //   }finally{
  //     categoryListLoading = false;
  //     update(['expense_vouchers_categories_list']);
  //   }
  //   update(["expense_vouchers_categories_list"]);
  //   EasyLoading.dismiss();
  // }


  bool isExpensePaymentMethodsListLoading = false;
  Future<void> getPaymentMethods() async {
    expensePaymentMethods.clear();
    isExpensePaymentMethodsListLoading = true;

    hasError.value = false;
    update(['expense_payment_methods_dd',]);

    try {
      var response = await ExpenseVoucherService.getPaymentMethods(
        usrToken: loginData!.token,
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        expensePaymentMethodsResponseModel =
            ExpensePaymentMethodsResponseModel.fromJson(response);

        if (expensePaymentMethodsResponseModel != null) {
          expensePaymentMethods.addAll(expensePaymentMethodsResponseModel!.paymentMethods);
          logger.i(expenseCategoriesList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        }
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isExpensePaymentMethodsListLoading = false;
      update(['expense_payment_methods_dd']);
    }
  }

  void addNewDueCollection({
    required int clientID,
    required int caID,
    required num amount,
    String? remarks,
  }) async {
    isAddCategoryLoading = true;
    update(["collection_list"]);
    RandomLottieLoader.show();
    try{
      var response = await DueCollectionService.addNewDueCollection(
        token: loginData!.token,
        caID: caID,
        clientID: clientID,
        amount: amount,
        remarks: remarks,
      );
      if (response != null) {

        if(response['success']){
          getDueCollectionList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['collection_list']);
    }
    update(["collection_list"]);
    RandomLottieLoader.hide();
  }

  void updateExpenseVoucher({
    required int id,
    required int clientID,
    required int caID,
    required num amount,
    String? remarks,
  }) async {
    isAddCategoryLoading = true;
    update(["collection_list"]);
    RandomLottieLoader.show();
    try{
      var response = await DueCollectionService.updateDueCollection(
        id: id,
        token: loginData!.token,
        caID: caID,
        clientId: clientID,
        amount: amount,
        remarks: remarks,
      );
      if (response != null) {

        if(response['success']){
          getDueCollectionList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['collection_list']);
    }
    update(["collection_list"]);
    RandomLottieLoader.hide();
  }

  void deleteDueCollection({
    required DueCollectionData transaction,
  }) async {
    isAddCategoryLoading = true;
    update(["collection_list"]);
    RandomLottieLoader.show();
    try{
      var response = await DueCollectionService.deleteDueCollection(
        id: transaction.id,
        token: loginData!.token,
      );
      if (response != null) {

        if(response['success']){
          getDueCollectionList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['collection_list']);
    }
    update(["collection_list"]);
    RandomLottieLoader.hide();
  }


  //Client Ledger

  bool isClientLedgerListLoading = false;
  bool isClientLedgerListLoadingMore = false;

  ClientLedgerListResponseModel? clientLedgerListResponseModel;
  List<ClientLedgerData> clientLedgerList = [];

  Future<void> getClientLedger({ String? search, int page = 1}) async {
    isClientLedgerListLoading = page == 1;
    if(page == 1){
      dueCollectionList.clear();
    }
    isClientLedgerListLoadingMore = page > 1;

    hasError.value = false;
    update(['client_ledger_total_widget','client_ledger']);

    try {
      var response = await DueCollectionService.getClientLedgerList(
        usrToken: loginData!.token,
        page: page,
        search: search,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        clientLedgerListResponseModel =
            ClientLedgerListResponseModel.fromJson(response);

        if (clientLedgerListResponseModel != null && clientLedgerListResponseModel!.data != null) {
          clientLedgerList.addAll(clientLedgerListResponseModel!.data!.data!);
          logger.i(clientLedgerList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          clientLedgerList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        clientLedgerList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      clientLedgerList.clear();
      logger.e(e);
    } finally {
      isClientLedgerListLoading = false;
      isClientLedgerListLoadingMore = false;
      update(['client_ledger_total_widget','client_ledger']);
    }
  }


  //Client ledger statement
  bool isClientLedgerStatementListLoading = false;
  bool isClientLedgerStatementListLoadingMore = false;

  ClientLedgerStatementResponseModel? clientLedgerStatementResponseModel;

  Future<void> getClientLedgerStatement({ String? search,required int id}) async {
    isClientLedgerStatementListLoading = true;
    // if(page == 1){
    //   dueCollectionList.clear();
    // }
    // isClientLedgerStatementListLoadingMore = page > 1;

    hasError.value = false;
    update(['client_ledger_statement']);

    try {
      var response = await DueCollectionService.getClientLedgerStatementList(
        usrToken: loginData!.token,
        id: id,
        search: search,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        clientLedgerStatementResponseModel =
            ClientLedgerStatementResponseModel.fromJson(response);
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isClientLedgerStatementListLoading = false;
      isClientLedgerStatementListLoadingMore = false;
      update(['client_ledger_statement']);
    }
  }
}