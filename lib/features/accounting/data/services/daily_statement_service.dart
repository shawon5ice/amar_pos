import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class DailyStatementService {
  static Future<dynamic> getDailyStatement({
    required String usrToken,
    required int page,
    required String? search,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: "accounting/report/get-daily-statement-report",
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": "2024-12-01"
        });
    return response;
  }


  static Future<void> downloadList({required bool isPdf,required bool saleHistory, required String fileName,
    required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,

  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
    };

    String downloadUrl = "";

    if(saleHistory){
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/purchase/download-pdf-purchase-list/";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/purchase/download-excel-purchase-list";
      }
    }else{
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/purchase/download-pdf-purchase-product/";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/purchase/download-excel-purchase-product/";
      }
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,);
  }
}
