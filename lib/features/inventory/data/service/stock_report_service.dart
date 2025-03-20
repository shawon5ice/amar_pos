import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/core/network/download/file_downloader.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';
import 'package:dio/dio.dart';

class StockReportService {
  static Future<dynamic> getStockReportList({
    required String usrToken,
    required int page,
    String? search,
    int? brandId,
    int? categoryId,
    int? storeId,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getStockReportList,
        parameter: {
          "page": page,
          "limit": 10,
          "search": search,
          "brand_id": brandId,
          "category_id": categoryId,
          "store_id": storeId,
        });
    return response;
  }

  static Future<dynamic> getStockLedgerList({
    required String usrToken,
    required int page,
    int? storeId,
    int? productId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getStockLedgerList,
        parameter: {
          "page": page,
          "limit": 10,
          "store_id": storeId,
          "product_id": productId,
          "start_date": startDate,
          "end_date": endDate,
        });
    return response;
  }


  static downloadStockLedgerReport({required String usrToken, required bool isPdf,     int? storeId, required String fileName, required BuildContext context,
    int? productId,
    DateTime? startDate,
    DateTime? endDate,}) async {
    logger.d("PDF: $isPdf");

    String downloadUrl =  "${NetWorkStrings.baseUrl}/inventory/${isPdf? "download-pdf-product-stock-ledger": "download-excel-product-stock-ledger"}?store_id=$storeId&product_id=$productId&start_date=${formatDate(startDate!)}&end_date=${formatDate(endDate!)}";

    FileDownloader().downloadFile(url: downloadUrl, fileName: fileName);
  }

  static Future<void> downloadList({required bool isPdf, required String fileName,
    required String usrToken, bool? shouldPrint, String? search,
    int? categoryId,
    int? brandId,
    int? outletId,
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "search": search,
      "category_id": categoryId,
      "brand_id": brandId,
      "outlet_id" : outletId
    };

    logger.i(query);

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/inventory/download-pdf-product-stock/";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/inventory/download-excel-product-stock/";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      shouldPrint: shouldPrint,
      fileName: fileName,);
  }
}
