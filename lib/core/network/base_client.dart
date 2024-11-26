import 'dart:convert';

import 'package:amar_pos/core/data/preference.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../features/auth/data/model/hive/login_data_helper.dart';
import '../../features/auth/presentation/ui/login_screen.dart';
import '../constants/app_strings.dart';
import '../constants/logger/logger.dart';
import '../widgets/methods/helper_methods.dart';
import 'network_strings.dart';

class BaseClient {
  static final Dio _dio = Dio();

  /// Common exception handler for Dio errors
  static void _handleDioError(DioException error) {
    String errorMessage = AppStrings.kWentWrong;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timeout. Please try again.";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Request timeout. Please try again.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Server response timeout. Please try again.";
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        if (statusCode == 401) {
          goToSignInScreen();
          return;
        } else if (statusCode == 403) {
          errorMessage = "Forbidden access. You don't have permission.";
        } else if (statusCode == 404) {
          errorMessage = "Requested resource not found.";
        } else if(statusCode == 422){
          errorMessage = "Unprocessable input data";
          ErrorExtractor.showErrorDialog(Get.context!, error.response?.data);
        } else if (statusCode >= 500) {
          errorMessage = "Server error. Please try again later.";
        } else {
          errorMessage = "Error occurred: ${error.response?.statusMessage}";
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request was cancelled.";
        break;
      case DioExceptionType.unknown:
        errorMessage = "Unexpected error occurred. Please check your network.";
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Certificate verification failed. Please ensure your connection is secure.";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "Failed to connect to the server. Please check your internet connection.";
        break;
    }
    if(error.response?.statusCode != 422){
      NetWorkStrings.errorMessage = errorMessage;
      Methods.showSnackbar(msg: errorMessage, duration: 3);
    }

  }

  /// Redirects user to login screen
  static void goToSignInScreen() {
    LoginDataBoxManager().loginData = null;
    Preference.setLoggedInFlag(false);
    Methods.showSnackbar(msg: "Session expired. Please login again.");
    Get.offAllNamed(LoginScreen.routeName);
  }

  static void showRequestLog({String? token, String? url, String? requestType}){
    logger.i("$requestType request to :$url\nToken : $token");
  }

  /// GET request
  static Future<dynamic> getData({
    String? token,
    required String api,
    dynamic parameter,
    bool? fullUrlGiven,
  }) async {
    String url = fullUrlGiven == true ? api : '${NetWorkStrings.baseUrl}/$api';
    showRequestLog(url: url, token: token, requestType: "GET");
    try {
      final response = await _dio.get(
        url,
        options: token != null
            ? Options(
          headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
          contentType: "application/x-www-form-urlencoded",
        )
            : null,
        queryParameters: parameter,
      );
      logger.i('GET Response: ${response.statusCode}');
      return response.data;
    } on DioException catch (error) {
      logger.e(error);
      _handleDioError(error);
    } catch (error) {
      logger.e(error);
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }
  }

  /// POST request
  static Future<dynamic> postData({
    required String api,
    String? token,
    dynamic body,
    bool? fullUrlGiven,
  }) async {
    String url = fullUrlGiven == true ? api : '${NetWorkStrings.baseUrl}/$api';
    showRequestLog(url: url, token: token, requestType: "POST");
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      logger.i('POST Response: ${response.statusCode}');
      return response.data;
    } on DioException catch (error) {
      logger.e(error);
      _handleDioError(error);
    } catch (error) {
      logger.e(error);
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }
  }

  /// PUT request
  static Future<dynamic> updateData({
    required String api,
    String? token,
    dynamic body,
    bool? fullUrlGiven,
  }) async {
    String url = fullUrlGiven == true ? api : '${NetWorkStrings.baseUrl}/$api';
    showRequestLog(url: url, token: token, requestType: "UPDATE");
    try {
      final response = await _dio.put(
        url,
        data: body,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      logger.i('PUT Response: ${response.statusCode}');
      return response.data;
    } on DioException catch (error) {
      logger.e(error);
      _handleDioError(error);
    } catch (error) {
      logger.e(error);
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }
  }

  /// DELETE request
  static Future<dynamic> deleteData({
    required String api,
    String? token,
    bool? fullUrlGiven,
  }) async {
    String url = fullUrlGiven == true ? api : '${NetWorkStrings.baseUrl}/$api';
    showRequestLog(url: url, token: token, requestType: "DELETE");
    try {
      final response = await _dio.delete(
        url,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      logger.i('DELETE Response: ${response.statusCode}');
      return response.data;
    } on DioException catch (error) {
      logger.e(error);
      _handleDioError(error);
    } catch (error) {
      logger.e(error);
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }
  }
}
