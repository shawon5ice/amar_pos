import 'dart:async';
import 'package:amar_pos/features/inventory/data/service/product_service.dart';
import 'package:amar_pos/features/inventory/data/service/stock_report_service.dart';
import 'package:amar_pos/features/inventory/data/stock_report/stock_ledger_list_response_model.dart';
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
  bool isStockLedgerListLoading = false;
  bool isLoadingMore = false;
  bool isActionLoading = false;
  bool filterListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;


  StockReportListResponseModel? stockReportListResponseModel;
  List<StockReport> stockReportList = [];

  List<StockLedger> stockLedgerList = [];
  StockLedgerListResponseModel? stockLedgerListResponseModel;

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
      update(['stock_report_list']);
    }
  }


  //Stock Ledger
  Future<void> getStockLedgerList({
    required int page,
    required int storeId,
    required int productId,
    required String startDate,
    required String endDate,
  }) async {
    if (page == 1) {
      isStockLedgerListLoading = true;
      stockLedgerList.clear();
    } else {
      isLoadingMore = true;
    }

    hasError = false;
    update(['stock_ledger_list']);
    try {
      var response = await StockReportService.getStockLedgerList(
        usrToken: loginData!.token,
        page: page,
        storeId: storeId,
        productId: productId,
        startDate: startDate,
        endDate: endDate,
      );

      if (response != null) {
        logger.d(response);
        stockLedgerListResponseModel =
            StockLedgerListResponseModel.fromJson(response);

        if (stockLedgerListResponseModel != null) {
          stockLedgerList.addAll(stockLedgerListResponseModel!.data.stockLedgerList);
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
      isStockLedgerListLoading = false;
      isLoadingMore = false;
      update(['stock_ledger_list']);
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

}
