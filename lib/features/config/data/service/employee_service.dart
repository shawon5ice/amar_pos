import 'package:dio/dio.dart';
import 'dart:io';

import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';


class EmployeeService {
  static Future<dynamic> getAll({
    required String usrToken,
  }) async {
    logger.i("HHH");
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllEmployees,
    );
    return response;
  }

  static Future<dynamic> getAllOutletDD({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllOutletsDD,
    );
    return response;
  }

  static Future<dynamic>getPermissions({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "get-all-permissions",);
    return response;
  }


  static Future<dynamic> store({
    required String name,
    required String phoneNo,
    required String address,
    required String token,
    required int allowLogin,
    required int storeId,
    String? photo,
    String? email,
    String? password,
    String? confirmPassword,
  }) async {

    FormData formData = FormData.fromMap({
      "name": name,
      "phone": phoneNo,
      "address": address,
      "allow_login": allowLogin,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      "store_id": storeId,
    });

    if (photo != null && !photo.contains("http")) {
      formData.files.add(
        MapEntry(
          "photo",
          await MultipartFile.fromFile(
            photo,
            filename: photo.split('/').last, // Add file name
          ),
        ),
      );
    }

    var response = await BaseClient.postData(
      token: token,
      api: NetWorkStrings.addEmployee,
      body: formData,
    );
    return response;
  }

  Future<String> downloadAndSaveImage(String imageUrl) async {
    try {
      // Get the temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Create a unique file path
      String filePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Download the image
      Dio dio = Dio();
      await dio.download(imageUrl, filePath);

      print('Image saved at: $filePath');
      return filePath; // Return the file path
    } catch (e) {
      print('Error saving image: $e');
      return '';
    }
  }

  static Future<dynamic> update({
    required int employeeId,
    required String name,
    required String phoneNo,
    required String address,
    required String token,
    required int allowLogin,
    required int storeId,
    String? photo,
    String? email,
    String? password,
    String? confirmPassword,
  }) async {

    FormData formData = FormData.fromMap({
      "name": name,
      "phone": phoneNo,
      "address": address,
      "allow_login": allowLogin,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      "store_id": storeId,
    });

    if (photo != null && !photo.contains("http")) {
      formData.files.add(
        MapEntry(
          "photo",
          await MultipartFile.fromFile(
            photo,
            filename: photo.split('/').last, // Add file name
          ),
        ),
      );
    }


    var response = await BaseClient.postData(
      token: token,
      api: "${NetWorkStrings.updateEmployee}$employeeId",
      body: formData,
    );
    return response;
  }

  static Future<dynamic> delete({
    required int employeeId,
    required String token,
  }) async {

    var response = await BaseClient.deleteData(
      token: token,
      api: "${NetWorkStrings.deleteEmployee}$employeeId",
    );
    logger.e(response);
    return response;
  }

  static Future<dynamic> changeStatus({
    required int employeeId,
    required String token,
  }) async {

    var response = await BaseClient.getData(
      token: token,
      api: "${NetWorkStrings.changeStatusOfEmployee}$employeeId",
    );
    logger.e(response);
    return response;
  }
}
