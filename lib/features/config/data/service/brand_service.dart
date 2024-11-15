import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';
import 'package:dio/dio.dart';

class BrandService {
  static Future<dynamic> getAllBrands({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllBrands,
    );
    return response;
  }

  static Future<dynamic> addBrand({
    required String brandName,
    required String brandLogo,
    required String token,
  }) async {
    FormData formData = FormData.fromMap({
      'logo': await MultipartFile.fromFile(
        brandLogo,
        filename: brandLogo.split('/').last, // Add file name
      ),
      'name': brandName, // Include other fields if needed
    });

    var response = await BaseClient.postData(
      token: token,
      api: NetWorkStrings.addBrand,
      body: formData,
    );
    return response;
  }

  static Future<dynamic> updateBrand({
    required String brandName,
    required String brandLogo,
    required int brandId,
    required String token,
  }) async {
    FormData formData = FormData.fromMap({
      'logo': await MultipartFile.fromFile(
        brandLogo,
        filename: brandLogo.split('/').last, // Add file name
      ),
      'name': brandName, // Include other fields if needed
    });

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
