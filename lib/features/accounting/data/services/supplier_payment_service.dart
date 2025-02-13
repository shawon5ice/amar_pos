import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class SupplierPaymentService {
  static Future<dynamic> getSupplierPaymentList({
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
        api: "due_payment/get-payment-list",
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


  static Future<void> downloadList({required bool isPdf,required bool supplierLedger, required String fileName,
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

    if(supplierLedger){
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/due_payment/download-pdf-supplier-ledger-list";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/due_payment/download-excel-supplier-ledger-list";
      }
    }else{
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/due_payment/download-pdf-payment-list";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/due_payment/download-excel-payment-list";
      }
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,);
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
      downloadUrl = "${NetWorkStrings.baseUrl}/due_payment/download-pdf-supplier-ledger-statement/$clientID";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/due_payment/download-excel-supplier-ledger-statement/$clientID";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,);
  }

  static Future<dynamic> addNewSupplierPayment({
    required int supplierID,
    required int caID,
    required num amount,
    String? remarks,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "due_payment/store",
      body: {
        "supplier_id": supplierID,
        "ca_id":caID,
        "amount": amount,
        "remarks": remarks,
      },
    );
    return response;
  }

  static Future<dynamic> updateSupplierPayment({
    required int id,
    required int supplierID,
    required int caID,
    required num amount,
    String? remarks,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "due_payment/update/$id",
      body: {
        "supplier_id": supplierID,
        "ca_id":caID,
        "amount": amount,
        "remarks": remarks,
      },
    );
    return response;
  }


  static Future<dynamic> deleteSupplierPayment({
    required int id,
    required String token,
  }) async {

    var response = await BaseClient.deleteData(
      token: token,
      api: "due_payment/delete/$id",
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
  static Future<dynamic> getSupplierLedgerList({
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
        api: "due_payment/get-supplier-ledger-list",
        parameter: query);
    return response;
  }


  //Client ledger statement
  static Future<dynamic> getSupplierLedgerStatementList({
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
        api: "due_payment/get-supplier-ledger-statement/$id",
        parameter: query);
    return response;
  }
}
