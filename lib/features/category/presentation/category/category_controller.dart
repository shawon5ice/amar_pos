import 'package:amar_pos/features/category/data/model/category/category_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  List<Category> categories = [];
  bool isAddBrandLoading = false;

  void addNewCategory({
    required String categoryName,
  }) async {
    isAddBrandLoading = true;
    update(["new_category_list"]);
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 2));
    categories.add(Category(categoryName: categoryName));
    update(["new_category_list"]);
    EasyLoading.dismiss();
  }

  void editCategory({
    required Category category,
    required String categoryName,
  }) async {
    isAddBrandLoading = true;
    update(["new_category_list"]);
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 2));
    int index = categories.indexOf(category);
    categories[index] = Category(categoryName: categoryName);
    update(["new_category_list"]);
    EasyLoading.dismiss();
  }

  void deleteCategory({
    required Category category,
  }) async {
    isAddBrandLoading = true;
    update(["new_category_list"]);
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 2));
    categories.remove(category);
    update(["new_category_list"]);
    EasyLoading.dismiss();
  }
}
