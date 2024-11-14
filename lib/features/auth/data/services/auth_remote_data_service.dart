

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';

class AuthRemoteDataService{
  static Future<dynamic> signIn({
    required String email,
    required String pass,
  }) async {
    var response = await BaseClient.postData(
      api: AppStrings.kLoginUrl,
      body: {
        "email": email,
        "password": pass,
      },
    );
    logger.d(response);
    return response;
  }

  // //Reset password
  // static Future<dynamic> sendOTP({
  //   required String phoneNumber,
  //   required bool isForVerification,
  //   required String otp
  // }) async {
  //   var response = await BaseClient.postData(
  //     fullUrlGiven: true,
  //     api: AppStrings.kBaseUrl + (isForVerification ?AppStrings.kSendOTPVerify:AppStrings.kSendOTPForgetPass),
  //     body: isForVerification
  //         ? {"medium": phoneNumber, "otp": otp, "type": 4, "check_place": 1}
  //         : {"phone": phoneNumber, "type": 4, "check_place": 1},
  //   );
  //   return response;
  // }

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