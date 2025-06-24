import 'package:amar_pos/features/inventory/presentation/stock_transfer/data/models/create_stock_transfer_request_model.dart';
import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';

import '../../../../../core/constants/logger/logger.dart';
import '../../../../../core/network/base_client.dart';
import '../../../../../core/network/download/file_downloader.dart';
import '../../../../../core/network/network_strings.dart';


class StockTransferService {
  static Future<dynamic> getAllProductList({
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
          "limit": 50
        });
    return response;
  }

  static Future<dynamic> getBillingPaymentMethods(
      {required String usrToken}) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getBillingPaymentMethods,
        parameter: {
          "sale_type" : "wholesale",
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

  static Future<dynamic> getAllSupplierList({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllSupplierList,
        parameter: {
          "status": 1,
        });
    return response;
  }

  static Future<dynamic> createStockTransfer({
    required String usrToken,
    required CreateStockTransferRequestModel stockTransferRequestModel,
  }) async {
    logger.i(stockTransferRequestModel.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: "inventory/stock_transfer/create",
      body: stockTransferRequestModel.toJson(),
    );
    return response;
  }

  static Future<dynamic> updateStockTransferOrder({
    required String usrToken,
    required CreateStockTransferRequestModel model,
    required int orderId,
  }) async {
    logger.i(model.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: 'inventory/stock_transfer/update/$orderId',
      body: model.toJson(),
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

  static downloadStockTransferInvoice(
      {required String usrToken, required int orderId, required String fileName, bool? shouldPrint}) async {
    // logger.d("PDF: $isPdf");

    String downloadUrl =
        "${NetWorkStrings.baseUrl}/inventory/stock_transfer/download-invoice/$orderId";

    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      shouldPrint: shouldPrint,
      fileName: fileName,);
  }

  static Future<dynamic> getStockTransferHistoryDetails({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "inventory/stock_transfer/get-details/$id",
    );
    return response;
  }

  static Future<dynamic> deleteStockTransfer({
    required String usrToken,
    required int stockTransferId}) async {
    var response = await BaseClient.deleteData(
      token: usrToken,
      api: 'inventory/stock_transfer/delete/$stockTransferId',);
    return response;
  }

  static Future<dynamic> receiveStockTransfer({
    required String usrToken,
    required int stockTransferId}) async {
    var response = await BaseClient.postData(
      token: usrToken,
      api: 'inventory/stock_transfer/received/$stockTransferId',);
    return response;
  }

  static Future<void> downloadList({required bool isPdf, required String fileName,
    required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,
    required int? type,
    bool? shouldPrint
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
      'status': type,
    };

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/inventory/stock_transfer/download-pdf-transfer-list";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/inventory/stock_transfer/download-excel-transfer-list";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      shouldPrint: shouldPrint,
      fileName: fileName,);
  }

  static Future<dynamic> getStockTransferHistory({
    required String usrToken,
    required int page,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    int? status
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: "inventory/stock_transfer/get-transfer-list",
        parameter: {
          "status": status,
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "limit": 10,
        });
    return response;
  }

  static Future<dynamic> getPurchaseProducts({
    required String usrToken,
    required int page,
    String? search,
    int? saleType,
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? brandId,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: "purchase/get-purchase-product-list",
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "sale_type": saleType,
          "category_id": categoryId,
          "brand_id": brandId,
          "limit": 10,
        });
    return response;
  }

  static Future<dynamic> getPurchaseOrderDetails({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "purchase/get-purchase-details/$id",
    );
    return response;
  }
}
