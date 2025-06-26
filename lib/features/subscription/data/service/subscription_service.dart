import '../../../../core/network/base_client.dart';

class SubscriptionService{
  static Future<dynamic> getSubscriptionList({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "subscription/get-package-list",
    );
    return response;
  }

  static Future<dynamic> getSubscriptionDetails({
    required String usrToken,
    required id,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "subscription/get-package-details/$id",
    );
    return response;
  }

  static Future<dynamic> getSubscriptionPaymentMethods({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "subscription/get-online-payment-methods",
    );
    return response;
  }
}