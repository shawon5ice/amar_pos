import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class MoneyAdjustmentService {
  static Future<dynamic> getMoneyAdjustmentList({
    required String usrToken,
    required int page,
    required String? search,
    required String? startDate,
    required String? endDate,
    required int moneyAdjustmentType,
  }) async {
    logger.d("Page: $page");

    Map<String, dynamic> query = {
      "page": page,
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
      "limit": 20,
      'type': moneyAdjustmentType,
    };
    logger.i(query);

    var response = await BaseClient.getData(
        token: usrToken,
        api: "money_adjustment/get-all-money-adjustment",
        parameter: query);
    return response;
  }

 static Future<dynamic> getExpenseCategories({
    required String usrToken,
   required int page,
   required int limit,
  }) async {

    var response = await BaseClient.getData(
        token: usrToken,
        api: "chart_of_accounts/get-expense-categories",
        parameter: {
          "page": page,
          "limit": limit,
        }
    );
    return response;
  }


  static Future<void> downloadList({required bool isPdf, required String fileName,
    required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,
    required bool? shouldPrint,
    required int type,
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
      "type": type,
    };

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/money_adjustment/download-pdf-money-adjustment-list";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/money_adjustment/download-excel-money-adjustment-list";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,
      shouldPrint: shouldPrint,
    );
  }

  static Future<void> downloadMoneyAdjustmentInvoice({required bool isPdf, required int invoiceID,
    required String usrToken,
    required String fileName,
    required bool? shouldPrint
  }) async {

    String downloadUrl = "${NetWorkStrings.baseUrl}/money_adjustment/download-invoice/$invoiceID";

    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      fileName: fileName,
      shouldPrint: shouldPrint,
    );
  }
  static Future<dynamic> storeNewMoneyAdjustment({
    required int caID,
    required int type,
    required num amount,
    String? remarks,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "money_adjustment/store",
      body: {
        "ca_id": caID,
        "amount": amount,
        "type": type,
        "remarks": remarks,
      },
    );
    return response;
  }

  static Future<dynamic> updateMoneyAdjustmentItem({
    required int id,
    required int caID,
    required int type,
    required num amount,
    String? remarks,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "money_adjustment/update/$id",
      body: {
        "ca_id": caID,
        "amount": amount,
        "type": type,
        "remarks": remarks,
      },
    );
    return response;
  }


  static Future<dynamic> deleteMoneyAdjustmentItem({
    required int id,
    required String token,
  }) async {

    var response = await BaseClient.deleteData(
      token: token,
      api: "money_adjustment/delete/$id",
    );
    return response;
  }


  static Future<dynamic> storeCategory({
    required String categoryName,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "pos/accounting/expense-category",
      body: {
        "name": categoryName,
        "remarks":'',
        "type": 2,
      },
    );
    return response;
  }


  static Future<dynamic> getPaymentMethods({
    required String usrToken,
  }) async {

    var response = await BaseClient.getData(
        token: usrToken,
        api: "chart_of_accounts/get-banks",
    );
    return response;
  }



  //Client Ledger
  static Future<dynamic> getClientLedgerList({
    required String usrToken,
    required int page,
    required String? search,
    required String? startDate,
    required String? endDate,
  }) async {
    logger.d("Page: $page");

    Map<String, dynamic> query = {
      "page": page,
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
      "limit": 20,
    };
    logger.i(query);

    var response = await BaseClient.getData(
        token: usrToken,
        api: "due_collection/get-client-ledger-list",
        parameter: query);
    return response;
  }


  //Client ledger statement
  static Future<dynamic> getClientLedgerStatementList({
    required String usrToken,
    required int id,
    required String? search,
    required String? startDate,
    required String? endDate,
  }) async {
    // logger.d("Page: $page");

    Map<String, dynamic> query = {
      // "page": page,
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
      "limit": 20,
    };
    logger.i(query);

    var response = await BaseClient.getData(
        token: usrToken,
        api: "due_collection/get-client-ledger-statement/$id",
        parameter: query);
    return response;
  }


  static Future<dynamic> getOutletForMoneyTransferList({
    required String usrToken,
  }) async {

    var response = await BaseClient.getData(
        token: usrToken,
        api: "money_transfer/get-outlets-for-money-transfer",);
    return response;
  }
}
