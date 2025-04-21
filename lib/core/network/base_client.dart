import 'dart:convert';

import 'package:amar_pos/core/data/preference.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import '../../features/auth/data/model/hive/login_data_helper.dart';
import '../../features/auth/presentation/ui/login_screen.dart';
import '../constants/app_strings.dart';
import '../constants/logger/logger.dart';
import '../widgets/methods/helper_methods.dart';
import 'network_strings.dart';
import 'package:dio/dio.dart' as dio;
class BaseClient {
  static  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),  // Timeout for connection
      receiveTimeout: const Duration(seconds: 15),  // Timeout for receiving data
    )
  );


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
    Map<String, dynamic> errorM = {
      'errors': {
        'x': [errorMessage],
      },
    };
    if(error.response?.statusCode != 422){
      ErrorExtractor.showErrorDialog(Get.context!, errorM);
      NetWorkStrings.errorMessage = errorMessage;
      // Methods.showSnackbar(msg: errorMessage, duration: 3);
    }

  }

  /// Redirects user to login screen
  static void goToSignInScreen() {
    LoginDataBoxManager().loginData = null;
    Preference.setLoggedInFlag(false);
    Methods.showSnackbar(msg: "Session expired. Please login again.");
    Get.offAllNamed(LoginScreen.routeName);
  }

  static void showRequestLog({String? token, String? url, String? requestType, dynamic parameter}){
    logger.i("$requestType request to :$url\nToken : $token\nParams: $parameter");
  }

  /// GET request
  static Future<dynamic> getData({
    String? token,
    required String api,
    dynamic parameter,
    bool? fullUrlGiven,
  }) async {
    String url = fullUrlGiven == true ? api : '${NetWorkStrings.baseUrl}/$api';
    showRequestLog(url: url, token: token, requestType: "GET", parameter: parameter);
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
      if(response.data['success']){
        return response.data;
      }else{
        // ErrorExtractor.showErrorDialog(Get.context!, response.data);
      }
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
    bool? fileTypeContent,
    dynamic body,
    bool? fullUrlGiven,
    bool? shouldExtractErros
  }) async {
    String url = fullUrlGiven == true ? api : '${NetWorkStrings.baseUrl}/$api';
    showRequestLog(url: url, token: token, requestType: "POST");
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token',},contentType: body is dio.FormData
            ? 'multipart/form-data'
            : 'application/json')
            : null,
      );
      logger.i('POST Response: ${response.statusCode}');
      logger.i('POST Response: ${response.data}');
      if((response.data['success'] || (!response.data['success'] && response.data['errors'] == null )|| shouldExtractErros != null)){
        return response.data;
      }else if(shouldExtractErros == null){
        ErrorExtractor.showErrorDialog(Get.context!, response.data);
      }
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
      if(response.data['success']){
        return response.data;
      }else{
        ErrorExtractor.showErrorDialog(Get.context!, response.data);
      }
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
      if(response.statusCode == 200){
        return response.data;
      }else{
        ErrorExtractor.showErrorDialog(Get.context!, response.data);
      }
    } on DioException catch (error) {
      logger.e(error);
      _handleDioError(error);
    } catch (error) {
      logger.e(error);
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }
  }
}
