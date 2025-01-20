import 'package:amar_pos/features/exchange/data/models/create_exchange_request_model.dart';
import 'package:amar_pos/features/exchange/data/models/exchange_history_response_model.dart';

import '../../../core/constants/logger/logger.dart';
import '../../../core/network/base_client.dart';
import '../../../core/network/download/file_downloader.dart';
import '../../../core/network/network_strings.dart';

class ExchangeService{
  static Future<dynamic> getProductList({
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

  static Future<dynamic> getAllCustomers({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllCustomer,
    );
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

  static Future<dynamic> getBillingPaymentMethods({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getBillingPaymentMethods,
        parameter: {
          "sale_type": "retail_sale",
        },
    );
    return response;
  }

  static Future<dynamic> createExchange({
    required String usrToken,
    required CreateExchangeRequestModel request,
  }) async {
    logger.i(request.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: 'exchange/create',
      body: request.toJson(),
    );
    return response;
  }

  static Future<dynamic> updateExchangeHistory({
    required String usrToken,
    required CreateExchangeRequestModel exchangeRequest,
    required int orderId,
  }) async {
    logger.i(exchangeRequest.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: 'exchange/update/$orderId',
      body: exchangeRequest.toJson(),
    );
    return response;
  }

  static Future<dynamic> getExchangeHistory({
    required String usrToken,
    required int page,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: "exchange/get-all-exchange-list",
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
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
        api: "exchange/get-exchange-product-list",
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

  static Future<dynamic> deleteExchangeHistory({
    required String usrToken,
    required ExchangeOrderInfo exchangeOrderInfo}) async {
    var response = await BaseClient.deleteData(
      token: usrToken,
      api: 'exchange/delete-order/${exchangeOrderInfo.id}',);
    return response;
  }


  static Future<void> downloadList({required bool isPdf,required bool returnHistory, required String fileName,
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

    if(returnHistory){
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/exchange/download-pdf-exchange-list";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/exchange/download-excel-exchange-list";
      }
    }else{
      if(isPdf){
        downloadUrl = "${NetWorkStrings.baseUrl}/exchange/download-pdf-exchange-product/";
      }else{
        downloadUrl = "${NetWorkStrings.baseUrl}/exchange/download-excel-exchange-product/";
      }
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,);
  }

  static downloadExchangeInvoice(
      {required String usrToken,
        required ExchangeOrderInfo exchangeOrderInfo}) async {

    String downloadUrl =
        "${NetWorkStrings.baseUrl}/exchange/download-exchange-invoice/${exchangeOrderInfo.id}";

    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      fileName: "${exchangeOrderInfo.orderNo}.pdf",);
  }


  static Future<dynamic> getExchangeOrderDetails({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "exchange/get-exchange-details/$id",
    );
    return response;
  }
}