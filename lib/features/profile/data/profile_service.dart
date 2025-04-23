import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';
import 'package:dio/dio.dart' as dio;
class ProfileService {
  static Future<dynamic> getProfileDetails({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: 'business_user/get-profile-details',
    );
    return response;
  }

  static Future<dynamic> saveProfileChanges({
    required String usrToken,
    required dio.FormData formData,
  }) async {

    var response = await BaseClient.postData(
      token: usrToken,
      api: 'business_user/update-profile',
      body: formData
    );
    return response;
  }

  static Future<dynamic> updateProfilePhoto({
    required String usrToken,
    required dio.FormData formData,
  }) async {

    var response = await BaseClient.postData(
      token: usrToken,
      api: 'business_user/update-profile-photo',
      body: formData
    );
    return response;
  }

  static Future<dynamic> sendOTP({
    required String usrToken,
    required String phoneNumber,
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(Duration(seconds: 2),);
    var response = await BaseClient.postData(
      fullUrlGiven: true,
      api: '${NetWorkStrings.baseUrl}/business_user/send-otp-for-change-password/',
      body: {"phone": phoneNumber, "old_password": oldPassword, "password": newPassword, "password_confirmation": newPassword},
    );
    return response;
  }

  static Future<dynamic> verifyOTP({
    required String phoneNumber,
    required String usrToken,
    required String otp,
  }) async {
    await Future.delayed(Duration(seconds: 2),);
    var response = await BaseClient.postData(
      fullUrlGiven: true,
      token: usrToken,
      api: '${NetWorkStrings.baseUrl}/verify-otp',
      body: {"medium": phoneNumber, "check_place": 1,'otp':otp},
    );
    return response;
  }
}
