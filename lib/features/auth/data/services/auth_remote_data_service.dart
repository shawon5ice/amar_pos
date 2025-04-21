import 'dart:convert';

import 'package:amar_pos/core/network/network_strings.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';

class AuthRemoteDataService {
  static Future<dynamic> signIn({
    required String email,
    required String pass,
  }) async {
    var response = await BaseClient.postData(
      api: NetWorkStrings.loginUrl,
      body: {
        "email": email,
        "password": pass,
      },
    );
    logger.d(response);
    return response;
  }

  //Reset password
  static Future<dynamic> sendOTP({
    required String phoneNumber,
  }) async {
    await Future.delayed(Duration(seconds: 2),);
    var response = await BaseClient.postData(
      fullUrlGiven: true,
      api: '${NetWorkStrings.baseUrl}/send-otp-phone',
      body: {"phone": phoneNumber, "check_place": 1},
    );
    return response;
  }

  static Future<dynamic> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    await Future.delayed(Duration(seconds: 2),);
    var response = await BaseClient.postData(
      fullUrlGiven: true,
      api: '${NetWorkStrings.baseUrl}/verify-otp',
      body: {"medium": phoneNumber, "check_place": 1,'otp':otp},
    );
    return response;
  }

  static Future<dynamic> signUp(var formData) async {
    await Future.delayed(Duration(seconds: 2),);

    var response = await BaseClient.postData(
      fullUrlGiven: true,
      shouldExtractErros : true,
      api: '${NetWorkStrings.baseUrl}/business/signup',
      body: formData,
    );
    return response;
  }

// static Future<dynamic> sendPasswordToChange({
//   required String phoneNumber,
//   required String password,
//   required String c_password,
// }) async {
//   var response = await BaseClient.postData(
//       api: AppStrings.kBaseUrl + AppStrings.kResetPasswordPhone,
//       body: {
//         "phone": phoneNumber,
//         "password":password,
//         "confirm_password": c_password,
//         "type": 4
//       },
//       fullUrlGiven: true,
//   );
//   return response;
// }
}
