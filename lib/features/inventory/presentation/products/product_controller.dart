import 'package:amar_pos/features/inventory/data/products/product_brand_category_warranty_unit_list_response_model.dart';
import 'package:amar_pos/features/inventory/data/products/product_list_response_model.dart';
import 'package:amar_pos/features/inventory/data/service/product_service.dart';
import 'package:get/get.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class ProductController extends GetxController {
  bool isProductListLoading = false;
  bool isLoadingMore = false;
  bool filterListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<String> selectedFilterItems = [];
  List<String> selectedBrands = [];
  List<String> selectedCategories = [];

  List<String> brands = [];
  List<String> categories = [];

  Categories? selectedCategory;

  ProductsListResponseModel? productsListResponseModel;
  List<ProductInfo> productList = [];

  ProductBrandCategoryWarrantyUnitListResponseModel?
      productBrandCategoryWarrantyUnitListResponseModel;

  bool hasError = false;

  Future<void> getAllProducts(
      {required bool activeStatus, required int page}) async {
    if (page == 1) {
      isProductListLoading = true;
      productList.clear();
    } else {
      isLoadingMore = true;
    }

    hasError = false; // Reset error before loading
    update(['product_list']);

    try {
      var response = await ProductService.getAllProducts(
        usrToken: loginData!.token,
        activeStatus: activeStatus,
        page: page,
      );

      if (response != null) {
        logger.d(response);
        productsListResponseModel =
            ProductsListResponseModel.fromJson(response);

        if (productsListResponseModel != null) {
          productList.addAll(productsListResponseModel!.data.productList);
        } else {
          hasError = true; // Error occurred while parsing data
        }
      } else {
        hasError = true; // Error occurred with the response
      }
    } catch (e) {
      hasError = true; // Handle any exceptions
      logger.e(e);
    } finally {
      if (page == 1) {
        isProductListLoading = false;
      } else {
        isLoadingMore = false;
      }
      update(['product_list']);
    }
  }

  Future<void> getCategoriesBrandWarrantyUnits() async {
    hasError = false; // Reset error before loading
    update(['filter_list']);

    try {
      var response = await ProductService.getCategoriesBrandWarrantyUnits(
        usrToken: loginData!.token,
      );

      if (response != null) {
        logger.d(response);
        productBrandCategoryWarrantyUnitListResponseModel =
            ProductBrandCategoryWarrantyUnitListResponseModel.fromJson(response);

        if (productBrandCategoryWarrantyUnitListResponseModel != null) {
          brands = productBrandCategoryWarrantyUnitListResponseModel!.data.brands.map((e) => e.name).toList();
          categories = productBrandCategoryWarrantyUnitListResponseModel!.data.categories.map((e) => e.name).toList();
        }
      }
    } catch (e) {
      hasError = true; // Handle any exceptions
      logger.e(e);
    } finally {
      update(['filter_list']);
    }
  }


  void addFilterItem(List<String> item){
    selectedFilterItems.addAll(item);
    update(['filter_list']);
    update(['filter_count']);
  }

  void deleteFilterItem(List<String> item){
    item.forEach(selectedFilterItems.remove);
    item.forEach(selectedCategories.remove);
    item.forEach(selectedBrands.remove);
    update(['filter_list']);
    update(['filter_count']);
  }

  void clearFilterItems(){
    selectedFilterItems.clear();
    update(['filter_list']);
    update(['filter_count']);
  }

  List<String> filterItems({required bool isBrand,required String search}){
    if(isBrand){
      return brands.where((e) => e.toLowerCase().contains(search.toLowerCase())).toList();
    }else{
      return categories.where((e) => e.toLowerCase().contains(search.toLowerCase())).toList();
    }
  }
}
