import 'package:amar_pos/core/constants/logger/logger.dart';

import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';
import 'package:dio/dio.dart';

class ProductService {
  static Future<dynamic> getAllProducts({
    required String usrToken,
    required bool activeStatus,
    required int page,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllProducts,
      parameter: {
        "status" : activeStatus ? 1 : 0,
        "page": page,
        "limit": 10,
      }
    );
    return response;
  }

  static Future<dynamic> addBrand({
    required String brandName,
    String? brandLogo,
    required String token,
  }) async {
    FormData formData = FormData.fromMap({
      'name': brandName, // Include other fields if needed
    });

    if (brandLogo != null) {
      formData.files.add(
        MapEntry(
          "logo",
          await MultipartFile.fromFile(
            brandLogo,
            filename: brandLogo.split('/').last, // Add file name
          ),
        ),
      );
    }

    var response = await BaseClient.postData(
      token: token,
      api: NetWorkStrings.addBrand,
      body: formData,
    );
    return response;
  }

  static Future<dynamic> updateBrand({
    required String brandName,
    String? brandLogo,
    required int brandId,
    required String token,
  }) async {
    FormData formData = FormData.fromMap({
      'name': brandName,
    });

    if (brandLogo != null && !brandLogo.contains("http")) {
      logger.d("HELLO MF");
      formData.files.add(
        MapEntry(
          "logo",
          await MultipartFile.fromFile(
            brandLogo,
            filename: brandLogo.split('/').last, // Add file name
          ),
        ),
      );
    }

    var response = await BaseClient.postData(
      token: token,
      api: "${NetWorkStrings.updateBrand}$brandId",
      body: formData,
    );
    return response;
  }

  static Future<dynamic> deleteBrand({
    required int brandId,
    required String token,
  }) async {
    var response = await BaseClient.deleteData(
      token: token,
      api: "${NetWorkStrings.deleteBrand}$brandId",
    );
    return response;
  }
}
