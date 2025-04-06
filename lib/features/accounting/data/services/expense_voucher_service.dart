import 'package:amar_pos/features/accounting/data/models/expense_voucher/expense_categories_response_model.dart';
import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class ExpenseVoucherService {
  static Future<dynamic> getExpenseVouchers({
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
        api: "expense_voucher/get-all-voucher",
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

  static Future<dynamic> storeExpenseVoucher({
    required int categoryID,
    required int caID,
    required num amount,
    String? remarks,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "expense_voucher/store",
      body: {
        "category_id": categoryID,
        "ca_id":caID,
        "amount": amount,
        "remarks": remarks,
      },
    );
    return response;
  }

  static Future<dynamic> updateExpenseVoucher({
    required int id,
    required int categoryID,
    required int caID,
    required num amount,
    String? remarks,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: "expense_voucher/update/$id",
      body: {
        "category_id": categoryID,
        "ca_id":caID,
        "amount": amount,
        "remarks": remarks,
      },
    );
    return response;
  }


  static Future<dynamic> deleteExpenseVoucher({
    required int id,
    required String token,
  }) async {

    var response = await BaseClient.deleteData(
      token: token,
      api: "expense_voucher/delete/$id",
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

  static Future<dynamic> updateExpenseCategories({
    required String categoryName,
    required ExpenseCategory category,
    required String token,
  }) async {
    var response = await BaseClient.postData(
      token: token,
      api: "chart_of_accounts/update/${category.id}",
      body: {
        "name": categoryName,
        "code":category.code,
        "root": category.root,
        "remarks": category.remarks,
        "type": 2,
      },
    );
    return response;
  }


  static Future<dynamic> deleteExpenseCategories({
    required int id,
    required String token,
  }) async {
    var response = await BaseClient.deleteData(
      token: token,
      api: "chart_of_accounts/delete/$id",
    );
    return response;
  }

}
