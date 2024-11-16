import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/methods/helper_methods.dart';
import 'package:amar_pos/features/config/data/model/category/category_model_response.dart';
import 'package:amar_pos/features/config/data/service/category_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class CategoryController extends GetxController {
  bool isAddCategoryLoading = false;
  bool categoryListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<Category> categoryList = [];
  List<Category> allCategoryCopy = [];
  CategoryModelResponse? categoryModelResponse;


  void getAllCategory() async {
    categoryListLoading = true;
    update(['category_list']);
    try{
      var response = await CategoryService.get(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        categoryModelResponse = CategoryModelResponse.fromJson(response);
        categoryList = categoryModelResponse!.categoryList;
        allCategoryCopy = categoryList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      categoryListLoading = false;
      update(['category_list']);
    }

  }

  void searchCategory({required String search}) async {
    try {
      // Show loading state
      isAddCategoryLoading = true;
      update(["brand_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        categoryList = allCategoryCopy;
      } else {
        // Perform case-insensitive search
        categoryList = allCategoryCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      isAddCategoryLoading = false;
      update(["category_list"]);
      EasyLoading.dismiss();
    }
  }


  void addNewCategory({
    required String categoryName,
  }) async {
    isAddCategoryLoading = true;
    update(["category_list"]);
    EasyLoading.show();
    try{
      var response = await CategoryService.store(
        token: loginData!.token,
        categoryName: categoryName,
      );
      if (response != null) {

        if(response['success']){
          getAllCategory();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      categoryListLoading = false;
      update(['category_list']);
    }
    update(["category_list"]);
    EasyLoading.dismiss();
  }

  void editCategory({
    required Category category,
    required String categoryName,
  }) async {
    isAddCategoryLoading = true;
    update(["category_list"]);
    EasyLoading.show();
    try{
      var response = await CategoryService.update(
        token: loginData!.token,
        categoryName: categoryName,
        brandId: category.id,
      );
      if (response != null) {

        if(response['success']){
          getAllCategory();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      categoryListLoading = false;
      update(['category_list']);
    }
    update(["category_list"]);
    EasyLoading.dismiss();
  }

  void deleteCategory({
    required Category category,
  }) async {
    isAddCategoryLoading = true;
    update(["category_list"]);
    EasyLoading.show();
    try{
      var response = await CategoryService.delete(
        token: loginData!.token,
        categoryId: category.id,
      );
      if (response != null) {

        if(response['success']){
          categoryList.remove(category);
          allCategoryCopy.remove(category);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      categoryListLoading = false;
      update(['category_list']);
    }
    update(["category_list"]);
    EasyLoading.dismiss();
  }
}
