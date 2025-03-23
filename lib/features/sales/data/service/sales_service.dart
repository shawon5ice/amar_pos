import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';
import '../models/create_order_model.dart';

class SalesService {
  static Future<dynamic> getSellingProductList({
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
      {required String usrToken, required bool isRetailSale}) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getBillingPaymentMethods,
        parameter: {
          "sale_type": isRetailSale ? "retail_sale" : "wholesale",
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

  static Future<dynamic> getAllClientList({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllClientList,
        parameter: {
          "status": 1,
        });
    return response;
  }

  static Future<dynamic> createSaleOrder({
    required String usrToken,
    required CreateSaleOrderModel saleOrderModel,
  }) async {
    logger.i(saleOrderModel.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: NetWorkStrings.createSaleOrder,
      body: saleOrderModel.toJson(),
    );
    return response;
  }

  static Future<dynamic> updateSaleOrder({
    required String usrToken,
    required CreateSaleOrderModel saleOrderModel,
    required int orderId,
  }) async {
    logger.i(saleOrderModel.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: 'order/update-order/$orderId',
      body: saleOrderModel.toJson(),
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

  static downloadSaleHistory(
      {required String usrToken,
      required String fileName,
      required int orderId,bool? shouldPrint}) async {
    // logger.d("PDF: $isPdf");

    String downloadUrl =
        "${NetWorkStrings.baseUrl}/order/download-order-invoice/$orderId";

    FileDownloader().downloadFile(
        url: downloadUrl,
        token: usrToken,
        fileName: fileName,
      shouldPrint: shouldPrint,
    );
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

  static Future<dynamic> deleteSaleHistory({
    required String usrToken,
    required SaleHistory saleHistory}) async {
    var response = await BaseClient.deleteData(
      token: usrToken,
      api: 'order/delete-order/${saleHistory.id}',);
    return response;
  }


  static Future<void> downloadList({required bool isPdf,required bool saleHistory, required String fileName,
      required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,
    required int? saleType,

  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
      "sale_type": saleType,
    };

    String downloadUrl = "";

    if(saleHistory){
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/order/download-pdf-order-list/";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/order/download-excel-order-list/";
      }
    }else{
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/order/download-pdf-sold-product/";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/order/download-excel-sold-product/";
      }
    }


    FileDownloader().downloadFile(
        url: downloadUrl,
        token: usrToken,
        query: query,
        fileName: fileName,);
  }
}
