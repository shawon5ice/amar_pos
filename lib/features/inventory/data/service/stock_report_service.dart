import 'package:amar_pos/core/constants/logger/logger.dart';

import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';
import 'package:dio/dio.dart';

class StockReportService {
  static Future<dynamic> getStockReportList({
    required String usrToken,
    required int page,
  }) async {
    logger.d("Page: $page");
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getStockReportList,
        parameter: {
          "page": page,
          "limit": 10,
        });
    return response;
  }

  static Future<dynamic> getCategoriesBrandWarrantyUnits({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getProductCategoriesBrandsUnitsWarranties,
    );
    return response;
  }

  static Future<dynamic> store({
    required String token,
    required String sku,
    required String name,
    int? brandId,
    required int categoryId,
    required int unitId,
    int? warrantyId,
    required num wholesalePrice,
    required num mrpPrice,
    num? vat,
    num? alertQuantity,
    String? mfgDate,
    String? expiredDate,
    String? photo,
  }) async {
    FormData formData = FormData.fromMap({
      "sku": sku,
      "name": name,
      "brand_id": brandId,
      "category_id": categoryId,
      "unit_id": unitId,
      "warranty_id": warrantyId,
      "wholesale_price": wholesalePrice,
      "mrp_price": mrpPrice,
      "vat": vat,
      "alert_quantity": alertQuantity,
      "mfg_date": mfgDate,
      "expired_date": expiredDate,
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
  }

  static Future<dynamic> update({
    required String token,
    required int id,
    required String name,
    int? brandId,
    required int categoryId,
    required int unitId,
    int? warrantyId,
    required num wholesalePrice,
    required num mrpPrice,
    num? vat,
    num? alertQuantity,
    String? mfgDate,
    String? expiredDate,
    String? photo,
  }) async {
    FormData formData = FormData.fromMap({
      "name": name,
      "brand_id": brandId,
      "category_id": categoryId,
      "unit_id": unitId,
      "warranty_id": warrantyId,
      "wholesale_price": wholesalePrice,
      "mrp_price": mrpPrice,
      "vat": vat,
      "alert_quantity": alertQuantity,
      "mfg_date": mfgDate,
      "expired_date": expiredDate,
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
      api: "${NetWorkStrings.updateProduct}id",
      body: formData,
    );
    return response;
  }

  static Future<dynamic> quickEdit({
    required String token,
    required int id,
    String? wholeSalePrice,
    String? mrpPrice,
    String? stockIn,
    String? stockOut,
  }) async {
    FormData formData = FormData.fromMap({
      "wholesale_price": wholeSalePrice,
      "mrp_price": mrpPrice,
      "stock_in": stockIn,
      "stock_out": stockOut
    });


    var response = await BaseClient.postData(
      token: token,
      api: "${NetWorkStrings.quickEditProduct}$id",
      body: formData,
    );
    return response;
  }

  static Future<dynamic> delete({
    required int productId,
    required String token,
  }) async {

    var response = await BaseClient.deleteData(
      token: token,
      api: "${NetWorkStrings.deleteProduct}$productId",
    );
    logger.e(response);
    return response;
  }

  static Future<dynamic> changeStatus({
    required int productId,
    required String token,
  }) async {

    var response = await BaseClient.getData(
      token: token,
      api: "${NetWorkStrings.changeStatusProduct}$productId",
    );
    logger.e(response);
    return response;
  }

  static Future<dynamic> generateBarcode({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: "${NetWorkStrings.generateProductBarcode}$id",
        parameter: {
          "id": id
        });
    return response;
  }
}
