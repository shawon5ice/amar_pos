import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import '../constants/app_strings.dart';
import '../constants/logger/logger.dart';
import '../widgets/methods/helper_methods.dart';
// import '../core.dart';

class BaseClient {
  static Future<dynamic> getData({
    String? token,
    required String api,
    dynamic parameter,
    String? apiVersion,
    bool? noDealer,
    bool? fullUrlGiven,
  }) async {
    String url = fullUrlGiven != null? api :'${AppStrings.kBaseUrl}/$api';

    if (noDealer != null) {
      url = AppStrings.kBaseUrl + api;
    }
    print('Sending request to: $url');
    if (token != null) {
      print('User Token: $token');
    }
    if (parameter != null) {
      print("Parameter: $parameter");
    }
    try {
      var response = await Dio().get(
        url,
        options: token != null
            ? Options(
            headers: {
              'Authorization': 'Bearer $token',
              "Accept":"application/json",
            },
            contentType: "application/x-www-form-urlencoded"
        )
            : null,
        queryParameters: parameter,
      );
      print('GET Method: ${response.statusCode}');
      print(url);
      log("GET Response:  ${jsonEncode(response.data)}");
      return response.data;
    } catch (e) {
      print(e.toString());
      Methods.showSnackbar(
        msg: AppStrings.kWentWrong,
      );
    }
  }

  static Future<dynamic> postData({
    required String api,
    String? token,
    dynamic body,
    String? apiVersion,
    bool? noDealer,
    bool? fullUrlGiven,
  }) async {
    // String apiV = apiVersion ?? ConstantStrings.kAPIVersion;
    // String url = ConstantStrings.kBaseUrl + apiV + api;
    String url = fullUrlGiven!= null? api: '${AppStrings.kBaseUrl}/$api';
    if (noDealer != null) {
      url = AppStrings.kBaseUrl + api;
    }
    print('Sending request to: $url');
    if (token != null) {
      print('User Token: $token');
    }
    if (body != null) {
      log("Post Body: $body");
    }
    try {
      var response = await Dio().post(
        url,
        options: token != null
            ? Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
            : null,
        data: body,
      );
      print('POST Method: ${response.statusCode}');
      print(url);
      log("POST Response:  ");
      logger.e(response);
      log(jsonEncode(response.data));
      return response.data;
    } catch (e) {
      print(e.toString());
      Methods.showSnackbar(
        msg: AppStrings.kWentWrong,
      );
    }
  }

  static Future<dynamic> updateData({
    required String api,
    String? token,
    dynamic body,
    String? apiVersion,
    bool? noDealer,
    bool? fullUrlGiven,
  }) async {
    // String apiV = apiVersion ?? ConstantStrings.kAPIVersion;
    // String url = ConstantStrings.kBaseUrl + apiV + api;
    String url = fullUrlGiven != null? api :'${AppStrings.kBaseUrl}/$api';
    if (noDealer != null) {
      url = AppStrings.kBaseUrl + api;
    }
    print('Sending request to: $url');
    if (token != null) {
      print('User Token: $token');
    }
    if (body != null) {
      log("Post Body: $body");
    }
    try {
      var response = await Dio().put(
        url,
        options: token != null
            ? Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
            : null,
        data: body,
      );
      print('POST Method: ${response.statusCode}');
      print(url);
      log("POST Response:  ");
      log(jsonEncode(response.data));
      return response.data;
    } catch (e) {
      print(e.toString());
      Methods.showSnackbar(
        msg: AppStrings.kWentWrong,
      );
    }
  }

  static Future<dynamic> patchData({
    required String api,
    String? token,
    dynamic body,
  }) async {
    // String apiV = apiVersion ?? ConstantStrings.kAPIVersion;
    // String url = ConstantStrings.kBaseUrl + apiV + api;
    String url = api;

    print('Sending request to: $url');
    if (token != null) {
      print('User Token: $token');
    }

    try {
      var response = await Dio().patch(
        url,
        data: body,
        options: token != null
            ? Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ) : null,
      );
      print('POST Method: ${response.statusCode}');
      print(url);
      log("POST Response:  ");
      log(jsonEncode(response.data));
      return response.data;
    } catch (e) {
      print(e.toString());
      Methods.showSnackbar(
        msg: AppStrings.kWentWrong,
      );
    }
  }

  static Future<dynamic> deleteData({
    required String api,
    String? token,
  }) async {
    // String apiV = apiVersion ?? ConstantStrings.kAPIVersion;
    // String url = ConstantStrings.kBaseUrl + apiV + api;
    String url = api;

    print('Sending request to: $url');
    if (token != null) {
      print('User Token: $token');
    }

    try {
      var response = await Dio().delete(
        url,
        options: token != null
            ? Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ) : null,
      );
      print('POST Method: ${response.statusCode}');
      print(url);
      log("POST Response:  ");
      log(jsonEncode(response.data));
      return response.data;
    } catch (e) {
      print(e.toString());
      Methods.showSnackbar(
        msg: AppStrings.kWentWrong,
      );
    }
  }
// static Future<dynamic> getData({required String api}) async {
//   print(ConstantStrings.kBaseUrl + api);
//   try {
//     var response = await Dio().get(ConstantStrings.kBaseUrl + api);
//     print('Base Client: ${response.statusCode}');
//     print(response.data);
//     return response.data;
//   } catch (e) {
//     print(e);
//   }
// }

// static Future<dynamic> postData(
//     {required String api, required dynamic body}) async {
//   try {
//     var response = await Dio().post(
//       ConstantStrings.kBaseUrl + api,
//       data: body,
//     );
//     return response.data;
//   } catch (e) {
//     print(e);
//   }
// }
}
