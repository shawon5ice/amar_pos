import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';

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
}