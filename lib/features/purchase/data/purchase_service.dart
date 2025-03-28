import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class PurchaseService {
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

  static Future<dynamic> createPurchaseOrder({
    required String usrToken,
    required CreatePurchaseOrderModel purchaseOrderModel,
  }) async {
    logger.i(purchaseOrderModel.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: "purchase/place-order",
      body: purchaseOrderModel.toJson(),
    );
    return response;
  }

  static Future<dynamic> updatePurchaseOrder({
    required String usrToken,
    required CreatePurchaseOrderModel purchaseOrderModel,
    required int orderId,
  }) async {
    logger.i(purchaseOrderModel.toJson());
    var response = await BaseClient.postData(
      token: usrToken,
      api: 'purchase/update-order/$orderId',
      body: purchaseOrderModel.toJson(),
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

  static downloadPurchaseHistory(
      {required String usrToken, required int orderId, required String fileName, bool? shouldPrint}) async {
    // logger.d("PDF: $isPdf");

    String downloadUrl =
        "${NetWorkStrings.baseUrl}/purchase/download-purchase-invoice/$orderId";

    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      shouldPrint: shouldPrint,
      fileName: fileName,);
  }

  static Future<dynamic> getPurchaseHistoryDetails({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "purchase/get-purchase-details/$id",
    );
    return response;
  }

  static Future<dynamic> deletePurchaseHistory({
    required String usrToken,
    required PurchaseOrderInfo purchaseOrderInfo}) async {
    var response = await BaseClient.deleteData(
      token: usrToken,
      api: 'purchase/delete-order/${purchaseOrderInfo.id}',);
    return response;
  }


  static Future<void> downloadList({required bool isPdf,required bool saleHistory, required String fileName,
    required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,
    required int? categoryId,
    required int? brandId,
    bool? shouldPrint
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
      'category_id': categoryId,
      'brand_id': brandId,
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
      shouldPrint: shouldPrint,
      fileName: fileName,);
  }

  static Future<dynamic> getPurchaseHistory({
    required String usrToken,
    required int page,
    String? search,
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? brandId,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: "purchase/get-all-purchase-list",
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": startDate,
          "end_date": endDate,
          "category_id": categoryId,
          "brand_id": brandId,
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
