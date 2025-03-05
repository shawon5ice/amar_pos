import 'package:amar_pos/core/constants/logger/logger.dart';

import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';
import 'package:dio/dio.dart';

class ProductService {
  static Future<dynamic> getAllProducts({
    required String usrToken,
    required bool activeStatus,
    required int page,
    String? search,
  }) async {
    logger.d("active: $activeStatus");
    var response = await BaseClient.getData(
        token: usrToken,
        api: NetWorkStrings.getAllProducts,
        parameter: {
          "status": activeStatus ? 1 : 0,
          "page": page,
          "limit": 10,
          "search": search,
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
    required int isVatApplicable,
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
      "is_vat_applicable": isVatApplicable,
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
      api: NetWorkStrings.addProduct,
      body: formData,
    );
    return response;

  }

  static Future<dynamic> update({
    required String token,
    required int id,
    required String name,
    required String sku,
    required int isVatApplicable,
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

    Map<String, dynamic> requestMap = {
      "name": name,
      "brand_id": brandId,
      "sku": sku,
      "category_id": categoryId,
      "unit_id": unitId,
      "warranty_id": warrantyId,
      "wholesale_price": wholesalePrice,
      "mrp_price": mrpPrice,
      "vat": vat,
      "alert_quantity": alertQuantity,
      "mfg_date": mfgDate,
      "is_vat_applicable": isVatApplicable,
      "expired_date": expiredDate,
    };


    logger.e(requestMap);

    FormData formData = FormData.fromMap(requestMap);

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
      api: "product/update/$id",
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

  static Future<void> downloadList({required bool isPdf, required String fileName,
    required String usrToken, bool? shouldPrint, required activeStatus, String? search,
    int? categoryId,
    int? brandId,
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "search": search,
      "status": activeStatus ? 1 : 0,
      "category_id": categoryId,
      "brand_id": brandId,
    };

    logger.i(query);

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/product/download-pdf-product-list/";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/product/download-excel-product-list/";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      shouldPrint: shouldPrint,
      fileName: fileName,);
  }

}
