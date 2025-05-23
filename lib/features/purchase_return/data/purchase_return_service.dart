import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/purchase_return/data/models/create_purchase_return_order_model.dart';
import 'package:amar_pos/features/purchase_return/data/models/purchase_return_history_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class PurchaseReturnService {
  static Future<dynamic> getAllProductList({
    required String usrToken,
    required int page,
    required String search,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllProducts,
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
        });
    return response;
  }

  static Future<dynamic> getBillingPaymentMethods(
      {required String usrToken}) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getBillingPaymentMethods,
        parameter: {
          "sale_type" : "wholesale",
        });
    return response;
  }

  static Future<dynamic> getAllServiceStuff({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllServiceStuff,
    );
    return response;
  }

  static Future<dynamic> getAllSupplierList({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllSupplierList,
        parameter: {
          "status": 1,
        });
    return response;
  }

  static Future<dynamic> createPurchaseReturnOrder({
    required String usrToken,
    required CreatePurchaseReturnOrderModel purchaseReturnOrderModel,
  }) async {
    logger.i(purchaseReturnOrderModel.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: "purchase_return/place-order",
      body: purchaseReturnOrderModel.toJson(),
    );
    return response;
  }

  static Future<dynamic> updatePurchaseReturnOrder({
    required String usrToken,
    required CreatePurchaseReturnOrderModel purchaseReturnOrderModel,
    required int orderId,
  }) async {
    logger.i(purchaseReturnOrderModel.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: 'purchase_return/update-order/$orderId',
      body: purchaseReturnOrderModel.toJson(),
    );
    return response;
  }

  static Future<dynamic> getSoldHistory({
    required String usrToken,
    required int page,
    String? search,
    int? saleType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllOrderList,
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "sale_type": saleType,
          "limit": 10,
        });
    return response;
  }

  static Future<dynamic> getSoldProducts({
    required String usrToken,
    required int page,
    String? search,
    int? saleType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllSoldProductList,
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "sale_type": saleType,
          "limit": 10,
        });
    return response;
  }

  static downloadPurchaseReturnHistory(
      {required String usrToken, required int orderId, required String fileName, bool? shouldPrint}) async {
    // logger.d("PDF: $isPdf");

    String downloadUrl =
        "${NetWorkStrings.baseUrl}/purchase_return/download-purchase-return-invoice/$orderId";

    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      shouldPrint: shouldPrint,
      fileName: fileName,);
  }

  static Future<dynamic> getSoldHistoryDetails({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "order/get-order-details/$id",
    );
    return response;
  }

  static Future<dynamic> deletePurchaseReturnHistory({
    required String usrToken,
    required PurchaseReturnOrderInfo purchaseReturnOrderInfo}) async {
    var response = await BaseClient.deleteData(
      token: usrToken,
      api: 'purchase_return/delete-order/${purchaseReturnOrderInfo.id}',);
    return response;
  }


  static Future<void> downloadList({required bool isPdf,required bool saleHistory, required String fileName,
    required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,
    required int? categoryId,
    required int? brandId,
    bool? shouldPrint,
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
      'category_id': categoryId,
      'brand_id': brandId,
    };

    String downloadUrl = "";

    if(saleHistory){
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/purchase_return/download-pdf-purchase-return-list";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/purchase_return/download-excel-purchase-return-list";
      }
    }else{
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/purchase_return/download-pdf-purchase-return-product";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/purchase_return/download-excel-purchase-return-product";
      }
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      shouldPrint: shouldPrint,
      fileName: fileName,);
  }

  static Future<dynamic> getPurchaseReturnHistory({
    required String usrToken,
    required int page,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? brandId,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: "purchase_return/get-all-purchase-return-list",
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "category_id": categoryId,
          "brand_id": brandId,
          "limit": 10,
        });
    return response;
  }

  static Future<dynamic> getPurchaseReturnProducts({
    required String usrToken,
    required int page,
    String? search,
    int? saleType,
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? brandId,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: "purchase_return/get-purchase-return-product-list",
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "sale_type": saleType,
          "category_id": categoryId,
          "brand_id": brandId,
          "limit": 10,
        });
    return response;
  }

  static Future<dynamic> getPurchaseOrderDetails({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "purchase_return/get-purchase-return-details/$id",
    );
    return response;
  }

  static Future<dynamic> getPurchaseReturnHistoryDetails({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "purchase_return/get-purchase-return-details/$id",
    );
    return response;
  }
}
