import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class ProfitOrLossService {
  static Future<dynamic> getProfitOrLoss({
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
    };
    logger.i(query);

    var response = await BaseClient.getData(
        token: usrToken,
        api: "accounting/report/get-profit-and-loss-report",
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
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
    };

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/accounting/report/download-pdf-profit-and-loss-report";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/accounting/report/download-excel-profit-and-loss-report";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,
      shouldPrint: shouldPrint,
    );
  }

  static Future<void> downloadStatement({required bool isPdf, required String fileName,
    required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,
    required int clientID,
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
    };

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/due_collection/download-pdf-client-ledger-statement/$clientID";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/due_collection/download-excel-client-ledger-statement/$clientID";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,);
  }


  static Future<void> downloadMoneyTransferInvoice({required bool isPdf, required int invoiceID,
    required String usrToken,
    required String fileName,
    required bool? shouldPrint
  }) async {

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/money_transfer/download-invoice/$invoiceID";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/money_transfer/download-invoice/$invoiceID";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      fileName: fileName,
      shouldPrint: shouldPrint,
    );
  }
  static Future<dynamic> storeNewMoneyTransfer({
    required int fromStoreID,
    required int fromAccountID,
    required int toAccountID,
    required int toStoreID,
    required num amount,
    String? remarks,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "money_transfer/store",
      body: {
        "from_store_id": fromStoreID,
        "from_ca_id": fromAccountID,
        "to_store_id": toStoreID,
        "to_ca_id": toAccountID,
        "amount": amount,
        "remarks": remarks,
      },
    );
    return response;
  }

  static Future<dynamic> updateMoneyTransfer({
    required int id,
    required int fromStoreID,
    required int fromAccountID,
    required int toAccountID,
    required int toStoreID,
    required num amount,
    String? remarks,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "money_transfer/update/$id",
      body: {
        "from_store_id": fromStoreID,
        "from_ca_id": fromAccountID,
        "to_store_id": toStoreID,
        "to_ca_id": toAccountID,
        "amount": amount,
        "remarks": remarks,
      },
    );
    return response;
  }


  static Future<dynamic> deleteMoneyTransferItem({
    required int id,
    required String token,
  }) async {

    var response = await BaseClient.deleteData(
      token: token,
      api: "money_transfer/delete/$id",
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
