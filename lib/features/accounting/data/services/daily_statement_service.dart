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
    required String? startDate,
    required String? endDate,
    int? caId,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: "accounting/report/get-daily-statement-report",
        parameter: {
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "ca_id": caId,
          "limit": 20
        });
    return response;
  }


  static Future<void> downloadList({required bool isPdf,required String fileName,
    required String usrToken,
    DateTime? startDate,
    DateTime? endDate,
    String? search,
    int? caId,
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
      "ca_id": caId,
    };

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/accounting/report/download-pdf-daily-statement-report";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/accounting/report/download-excel-daily-statement-report";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      fileName: fileName,
      query: query,);
  }
}
