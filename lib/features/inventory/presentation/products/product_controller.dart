import 'package:amar_pos/features/inventory/data/products/product_list_response_model.dart';
import 'package:amar_pos/features/inventory/data/service/product_service.dart';
import 'package:get/get.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class ProductController extends GetxController{
  bool isProductListLoading = false;
  bool isLoadingMore = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  ProductsListResponseModel? productsListResponseModel;
  List<ProductInfo> productList = [];

  bool hasError = false;

  Future<void> getAllProducts({required bool activeStatus, required int page}) async {
    if (page == 1) {
      isProductListLoading = true;
      productList.clear();
    } else {
      isLoadingMore = true;
    }

    hasError = false;  // Reset error before loading
    update(['product_list']);

    try {
      var response = await ProductService.getAllProducts(
        usrToken: loginData!.token,
        activeStatus: activeStatus,
        page: page,
      );

      if (response != null) {
        logger.d(response);
        productsListResponseModel = ProductsListResponseModel.fromJson(response);

        if (productsListResponseModel != null) {
          productList.addAll(productsListResponseModel!.data.productList);
        } else {
          hasError = true;  // Error occurred while parsing data
        }
      } else {
        hasError = true;  // Error occurred with the response
      }
    } catch (e) {
      hasError = true;  // Handle any exceptions
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

}