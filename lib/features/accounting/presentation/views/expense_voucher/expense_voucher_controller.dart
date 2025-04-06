import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_voucher_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_payment_methods_response_model.dart';
import 'package:amar_pos/features/accounting/data/services/expense_voucher_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/core.dart';
import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';
import '../../../data/models/expense_voucher/expense_categories_response_model.dart';
import '../../../data/models/expense_voucher/expense_voucher_response_model.dart';

class ExpenseVoucherController extends GetxController{

  bool isExpenseVouchersListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  List<TransactionData> expenseVouchersList = [];
  List<TransactionData> currentSearchList = [];
  ExpenseVoucherResponseModel? expenseVoucherResponseModel;

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


  Future<void> getExpenseVouchers(
      { String? search, int page = 1}) async {
    isExpenseVouchersListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      expenseVouchersList.clear();
    }
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['total_expense_vouchers','expense_vouchers_list']);

    try {
      var response = await ExpenseVoucherService.getExpenseVouchers(
        usrToken: loginData!.token,
        page: page,
        search: search,
        startDate: selectedDateTimeRange.value?.start.toString(),
        endDate: selectedDateTimeRange.value?.end.toString(),
      );

      logger.d(response);

      if (response != null) {
        logger.e(response);
        expenseVoucherResponseModel =
            ExpenseVoucherResponseModel.fromJson(response);

        if (expenseVoucherResponseModel != null && expenseVoucherResponseModel!.data != null) {
          expenseVouchersList.addAll(expenseVoucherResponseModel!.data!.data!);
          logger.i(expenseVouchersList.length);
          // if (currentSearchList.isNotEmpty) {
          //   lastFoundList.value = currentSearchList; // Update last found list
          // }
        } else {
          currentSearchList.clear(); // No results
        }
      } else {
        // hasError.value = true; // Error in response
        currentSearchList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      currentSearchList.clear();
      logger.e(e);
    } finally {
      isExpenseVouchersListLoading = false;
      isLoadingMore = false;
      update(['total_expense_vouchers','expense_vouchers_list']);
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

  void editCategory({
    required ExpenseCategory category,
    required String categoryName,
  }) async {
    isAddCategoryLoading = true;
    update(["expense_vouchers_categories_list"]);
    RandomLottieLoader.show();
    try{
      var response = await ExpenseVoucherService.updateExpenseCategories(
        token: loginData!.token,
        category: category,
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
      isExpenseCategoriesListLoading = false;
      update(['expense_vouchers_categories_list']);
    }
    update(["expense_vouchers_categories_list"]);
    RandomLottieLoader.hide();
  }

  void deleteCategory({
    required int id
  }) async {
    isAddCategoryLoading = true;
    update(["expense_vouchers_categories_list"]);
    RandomLottieLoader.show();
    try{
      var response = await ExpenseVoucherService.deleteExpenseCategories(
        token: loginData!.token,
        id: id
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
      isExpenseCategoriesListLoading = false;
      update(['expense_vouchers_categories_list']);
    }
    update(["expense_vouchers_categories_list"]);
    RandomLottieLoader.hide();
  }


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

  void addNewExpenseVoucher({
    required int categoryID,
    required int caID,
    required num amount,
    String? remarks,
  }) async {
    isAddCategoryLoading = true;
    update(["expense_vouchers_list"]);
    RandomLottieLoader.show();
    try{
      var response = await ExpenseVoucherService.storeExpenseVoucher(
        token: loginData!.token,
        caID: caID,
        categoryID: categoryID,
        amount: amount,
        remarks: remarks,
      );
      if (response != null) {

        if(response['success']){
          getExpenseVouchers();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['expense_vouchers_list']);
    }
    update(["expense_vouchers_list"]);
    RandomLottieLoader.hide();
  }

  void updateExpenseVoucher({
    required int id,
    required int categoryID,
    required int caID,
    required num amount,
    String? remarks,
  }) async {
    isAddCategoryLoading = true;
    update(["expense_vouchers_list"]);
    RandomLottieLoader.show();
    try{
      var response = await ExpenseVoucherService.updateExpenseVoucher(
        id: id,
        token: loginData!.token,
        caID: caID,
        categoryID: categoryID,
        amount: amount,
        remarks: remarks,
      );
      if (response != null) {

        if(response['success']){
          getExpenseVouchers();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['expense_vouchers_list']);
    }
    update(["expense_vouchers_list"]);
    RandomLottieLoader.hide();
  }

  void deleteExpenseVoucher({
    required TransactionData transaction,
  }) async {
    isAddCategoryLoading = true;
    update(["expense_vouchers_list"]);
    RandomLottieLoader.show();
    try{
      var response = await ExpenseVoucherService.deleteExpenseVoucher(
        id: transaction.id,
        token: loginData!.token,
      );
      if (response != null) {

        if(response['success']){
          getExpenseVouchers(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddCategoryLoading = false;
      update(['expense_vouchers_list']);
    }
    update(["expense_vouchers_list"]);
    RandomLottieLoader.hide();
  }
}