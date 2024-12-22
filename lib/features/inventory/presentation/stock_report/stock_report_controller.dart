import 'dart:async';

import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/inventory/data/products/product_brand_category_warranty_unit_list_response_model.dart';
import 'package:amar_pos/features/inventory/data/service/product_service.dart';
import 'package:amar_pos/features/inventory/data/service/stock_report_service.dart';
import 'package:amar_pos/features/inventory/data/stock_report/stock_report_list_reponse_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../data/products/product_list_response_model.dart';

class StockReportController extends GetxController {
  bool isStockReportListLoading = false;
  bool isLoadingMore = false;
  bool isActionLoading = false;
  bool filterListLoading = false;
  String generatedBarcode = "";
  bool barcodeGenerationLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<String> selectedFilterItems = [];
  List<String> selectedBrands = [];
  List<String> selectedCategories = [];

  List<String> brands = [];
  List<String> categories = [];


  StockReportListResponseModel? stockReportListResponseModel;
  List<StockReport> stockReportList = [];

  ProductBrandCategoryWarrantyUnitListResponseModel?
      productBrandCategoryWarrantyUnitListResponseModel;

  bool hasError = false;

  Future<void> getStockReportList({required int page, BuildContext? context}) async {
    if (page == 1) {
      isStockReportListLoading = true;
      stockReportList.clear();
    } else {
      isLoadingMore = true;
    }

    hasError = false; // Reset error before loading
    update(['stock_report_list']);
    // EasyLoading.show(
    //   status: "Loading..."
    // );
    RandomLottieLoader().show(context!);
    try {
      var response = await StockReportService.getStockReportList(
        usrToken: loginData!.token,
        page: page,
      );

      if (response != null) {
        logger.d(response);
        stockReportListResponseModel =
            StockReportListResponseModel.fromJson(response);

        if (stockReportListResponseModel != null) {
          stockReportList.addAll(stockReportListResponseModel!.stockReportResponse.stockReportList);
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
        isStockReportListLoading = false;
      } else {
        isLoadingMore = false;
      }
      EasyLoading.dismiss();
      RandomLottieLoader().hide();
      update(['stock_report_list']);
    }
  }


  //Add Product
  void addProduct({
    required String sku,
    required String name,
    int? brandId,
    required int categoryId,
    required int unitId,
    int? warrantyId,
    required num wholesalePrice,
    required num mrpPrice,
    num? vat,
    num? alertQuantity,
    String? mfgDate,
    String? expiredDate,
    String? photo,
  }) async {
    // Perform necessary validations

    EasyLoading.show();
    try {
      var response = await ProductService.store(
        token: loginData!.token,
        sku: sku,
        name: name,
        brandId: brandId,
        categoryId: categoryId,
        unitId: unitId,
        warrantyId: warrantyId,
        wholesalePrice: wholesalePrice,
        mrpPrice: mrpPrice,
        vat: vat,
        alertQuantity: alertQuantity,
        mfgDate: mfgDate,
        expiredDate: expiredDate,
        photo: photo,
      );

      logger.i(response);
      if (response != null && response['success']) {
        EasyLoading.dismiss();
        Get.back();
        getStockReportList( page: 1);
        Methods.showSnackbar(msg: response['message'], isSuccess: true);

      }
    } catch (e) {
      logger.e(e);
      Methods.showSnackbar(msg: "An error occurred", isSuccess: false);
    } finally {
      EasyLoading.dismiss();
    }
  }



  //Update product
  void updateProduct({
    required int id,
    required String name,
    required String sku,
    int? brandId,
    required int categoryId,
    required int unitId,
    int? warrantyId,
    required num wholesalePrice,
    required num mrpPrice,
    num? vat,
    num? alertQuantity,
    String? mfgDate,
    String? expiredDate,
    String? photo,
  }) async {
    // Perform necessary validations

    EasyLoading.show();
    try {
      var response = await ProductService.update(
        token: loginData!.token,
        id: id,
        name: name,
        brandId: brandId,
        categoryId: categoryId,
        unitId: unitId,
        warrantyId: warrantyId,
        wholesalePrice: wholesalePrice,
        mrpPrice: mrpPrice,
        vat: vat,
        alertQuantity: alertQuantity,
        mfgDate: mfgDate,
        expiredDate: expiredDate,
        photo: photo,
      );

      logger.i(response);
      if (response != null && response['success']) {
        EasyLoading.dismiss();
        Get.back();
        getStockReportList( page: 1);
        Methods.showSnackbar(msg: response['message'], isSuccess: true);

      }
    } catch (e) {
      logger.e(e);
      Methods.showSnackbar(msg: "An error occurred", isSuccess: false);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void quickEditProduct({
    required int id,
    String? wholeSalePrice,
    String? mrpPrice,
    String? stockIn,
    String? stockOut,
  }) async {
    // Perform necessary validations

    EasyLoading.show();
    try {
      var response = await ProductService.quickEdit(
        token: loginData!.token,
        id: id,
        wholeSalePrice: wholeSalePrice,
        mrpPrice: mrpPrice,
        stockOut: stockOut,
        stockIn: stockIn,
      );

      logger.i(response);
      if (response != null && response['success']) {
        EasyLoading.dismiss();
        Get.back();
        getStockReportList( page: 1);
        Methods.showSnackbar(msg: response['message'], isSuccess: true);

      }
    } catch (e) {
      logger.e(e);
      Methods.showSnackbar(msg: "An error occurred", isSuccess: false);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void generateBarcode({
    required int id,
  }) async {
    // Perform necessary validations
    generatedBarcode = "";
    barcodeGenerationLoading = true;
    update(['barcode_list']);
    EasyLoading.show();
    try {
      var response = await ProductService.generateBarcode(
        usrToken: loginData!.token,
        id: id,
      );

      logger.i(response);
      if (response != null && response['success']) {
        EasyLoading.dismiss();
        generatedBarcode = response['data'];
        barcodeGenerationLoading = false;
        update(['barcode_list']);
      }
    } catch (e) {
      logger.e(e);
      Methods.showSnackbar(msg: "An error occurred", isSuccess: false);
    } finally {
      EasyLoading.dismiss();
    }
  }



  void deleteProduct({
    required ProductInfo productInfo,
  }) async {
    isActionLoading = true;
    update(["stock_report_list"]);
    EasyLoading.show();
    try{
      var response = await ProductService.delete(
        token: loginData!.token,
        productId: productInfo.id,
      );
      if (response != null) {

        if(response['success']){
          getStockReportList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isActionLoading = false;
      update(['stock_report_list']);
    }
    update(["employee_list"]);
    EasyLoading.dismiss();
  }

  void changeStatusOfProduct({
    required ProductInfo productInfo,
  }) async {
    isActionLoading = true;
    update(["stock_report_list"]);
    EasyLoading.show();
    try{
      var response = await ProductService.changeStatus(
        token: loginData!.token,
        productId: productInfo.id,
      );
      if (response != null) {
        if(response['success']){
          getStockReportList(page: 1);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isActionLoading = false;
      update(['stock_report_list']);
    }
    update(["stock_report_list"]);
    EasyLoading.dismiss();
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
