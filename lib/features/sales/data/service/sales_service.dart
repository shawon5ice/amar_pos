import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';
import '../models/create_order_model.dart';

class SalesService{
  static Future<dynamic> getSellingProductList({
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

  static Future<dynamic> getBillingPaymentMethods({
    required String usrToken,
    required bool isRetailSale
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getBillingPaymentMethods,
        parameter: {
          "sale_type": isRetailSale ? "retail_sale": "wholesale",
        });
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

  static Future<dynamic> getAllClientList({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllClientList,
      parameter: {
          "status" : 1,
      }
    );
    return response;
  }

  static Future<dynamic> createSaleOrder({
    required String usrToken,
    required CreateSaleOrderModel saleOrderModel,
  }) async {
    logger.i(saleOrderModel.toJson());
    var response = await BaseClient.postData(
        token: usrToken,
        api: NetWorkStrings.createSaleOrder,
        body: saleOrderModel.toJson(),
    );
    return response;
  }

  static Future<dynamic> getSoldHistory({
    required String usrToken,
    required int page,
    String? search,
    bool? saleType,
    String? startDate,
    String? endDate,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllOrderList,
        parameter: {
          "status": 1,
          "page": page,
          "search": search,
          "start_date": startDate??'1/09/2024',
          "end_date": endDate??'5/01/2025',
          "sale_type": saleType,
        });
    return response;
  }
}