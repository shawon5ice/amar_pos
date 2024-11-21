import 'package:dio/dio.dart';
import 'dart:io';

import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';


class SupplierService {
  static Future<dynamic> get({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllSuppliers,
    );
    return response;
  }

  static Future<dynamic> store({
    required String name,
    required String phoneNo,
    required String address,
    required num balance,
    required String? supplierLogo,
    required String token,
  }) async {

    FormData formData = FormData.fromMap({
      "name": name,
      "phone_no": phoneNo,
      "address": address,
      "opening_balance": balance,
    });

    if (supplierLogo != null) {
      formData.files.add(
        MapEntry(
          "photo",
          await MultipartFile.fromFile(
            supplierLogo,
            filename: supplierLogo.split('/').last,
          ),
        ),
      );
    }

    var response = await BaseClient.postData(
      token: token,
      api: NetWorkStrings.addSupplier,
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
    required String supplierName,
    required String phoneNo,
    required String address,
    required String openingBalance,
    required String photo,
    required int supplierId,
    required String token,
  }) async {

    late FormData formData;
    if(!photo.contains("http") && photo.isNotEmpty){
      formData = FormData.fromMap({
        "name": supplierName,
        "phone_no": phoneNo,
        "address": address,
        "opening_balance": openingBalance,
        "photo": await MultipartFile.fromFile(
          photo,
          filename: photo.split('/').last,
        )
      });
    }else{
      formData = FormData.fromMap({
        "name": supplierName,
        "phone_no": phoneNo,
        "address": address,
        "opening_balance": openingBalance,
      });
    }


    var response = await BaseClient.postData(
      token: token,
      api: "${NetWorkStrings.updateSupplier}$supplierId",
      body: formData,
    );
    return response;
  }

  static Future<dynamic> delete({
    required int supplierId,
    required String token,
  }) async {

    var response = await BaseClient.deleteData(
      token: token,
      api: "${NetWorkStrings.deleteSupplier}$supplierId",
    );
    logger.e(response);
    return response;
  }

  static Future<dynamic> changeStatus({
    required int supplierId,
    required String token,
  }) async {

    var response = await BaseClient.getData(
      token: token,
      api: "${NetWorkStrings.changeStatusOfSupplier}$supplierId",
    );
    logger.e(response);
    return response;
  }
}
