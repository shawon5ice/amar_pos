import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
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

class ExpenseVoucherController extends GetxController{

  bool isExpenseVouchersListLoading = false;
  bool isExpenseCategoriesListLoading = false;
  bool isLoadingMore = false;
  RxBool hasError = false.obs;

  int? selectedOutletId;
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  List<TransactionData> dailyStatementList = [];
  List<TransactionData> currentSearchList = [];
  ExpenseVoucherResponseModel? expenseVoucherResponseModel;

  ExpenseCategoriesResponseModel? expenseCategoriesResponseModel;
  List<ExpenseCategory> expenseCategoriesList = [];


  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  onInit(){
    super.onInit();
    getExpenseVouchers(page: 1);
  }


  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }


  Future<void> getExpenseVouchers(
      { String? search, int page = 1}) async {
    isExpenseVouchersListLoading = page == 1; // Mark initial loading state
    if(page == 1){
      dailyStatementList.clear();
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
          dailyStatementList.addAll(expenseVoucherResponseModel!.data!.data!);
          logger.i(dailyStatementList.length);
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

  Future<void> getExpenseCategories({int page = 1}) async {
    if(page == 1){
      isExpenseCategoriesListLoading = true;
      expenseCategoriesList.clear();
    }else{
      isLoadingMore = true;
    }

    hasError.value = false;
    update(['expense_vouchers_categories_list']);

    try {
      var response = await ExpenseVoucherService.getExpenseCategories(
        usrToken: loginData!.token,
        page: page,
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
      update(['expense_vouchers_categories_list']);
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
}