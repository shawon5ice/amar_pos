
import 'package:amar_pos/features/return/data/models/return_history/return_history_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';
import '../models/create_return_order_model.dart';

class ReturnServices{
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

  static Future<dynamic> getBillingPaymentMethods({
    required String usrToken,
    required bool isRetailSale
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getBillingPaymentMethods,
        parameter: {
          "sale_type": isRetailSale ? "retail_sale": "wholesale",
        });
    return response;
  }

  static Future<dynamic> getAllServiceStuff({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllServiceStuff,);
    return response;
  }

  static Future<dynamic> getAllClientList({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllClientList,
      parameter: {
          "status" : 1,
      }
    );
    return response;
  }

  static Future<dynamic> createReturnOrder({
    required String usrToken,
    required CreateReturnOrderModel returnOrderModel,
  }) async {
    logger.i(returnOrderModel.toJson());
    var response = await BaseClient.postData(
        token: usrToken,
        api: 'return/create',
        body: returnOrderModel.toJson(),
    );
    return response;
  }

  static Future<dynamic> getReturnHistory({
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

  static Future<dynamic> getReturnProducts({
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

  static Future<dynamic> deleteReturnHistory({
    required String usrToken,
    required ReturnHistory returnHistory}) async {
    var response = await BaseClient.deleteData(
        token: usrToken,
        api: 'return/delete/${returnHistory.id}',);
    return response;
  }

  static downloadStockLedgerReport({required String usrToken, required BuildContext context, required ReturnHistory returnHistory}) async {
    // logger.d("PDF: $isPdf");

    String downloadUrl =  "${NetWorkStrings.baseUrl}/download-order-invoice/${returnHistory.id}";

    FileDownloader().downloadFile(url: downloadUrl, fileName: "${returnHistory.orderNo}.pdf" , context: context);
  }
}