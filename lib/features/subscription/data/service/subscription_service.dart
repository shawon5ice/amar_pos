import 'dart:convert';

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

  static Future<dynamic> getCurrentSubscriptionDetails({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "subscription/get-active-subscription",
    );
    // var data = {
    //   "success": false,
    //   "data": {
    //     "id": 98,
    //     "sl_no": "APS-GP-317023",
    //     "business_id": 3,
    //     "package_id": 1,
    //     "start_date": "2025-02-27",
    //     "end_date": "2030-04-29",
    //     "package_price": 1,
    //     "package_details": "This is a basic package.",
    //     "payment_method": 5,
    //     "payment_status": 1,
    //     "transaction_id": "CBR47RW5ZI"
    //   }
    // };
    return response;
  }

  static Future<dynamic> createSubscriptionOrder({
    required String usrToken,
    required int packageId,
    required int paymentMethodId,
  }) async {
    var response = await BaseClient.postData(
      token: usrToken,
      api: "subscription/package-subscription",
      body: {
        "package_id":packageId,
        "payment_method":paymentMethodId
      }
    );
    return response;
  }


  static Future<dynamic> processPayment({
    required String usrToken,
    required String orderNo,
    required String shortCode,
  }) async {
    var response = await BaseClient.postData(
        token: usrToken,
        api: shortCode.toLowerCase().contains("bkash") ? "bkash": "ssl-payment",
        body: {
          "order_no":orderNo,
        }
    );
   return response;
  }
}