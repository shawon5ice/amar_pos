import '../../../core/constants/logger/logger.dart';
import '../../../core/network/base_client.dart';
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
}