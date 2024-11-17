import 'dart:ffi';

import 'package:amar_pos/core/responsive/pixel_perfect.dart';

import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';
import 'package:dio/dio.dart';


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
    required String supplierLogo,
    required String token,
  }) async {

    FormData formData = FormData.fromMap({
      "name": name,
      "phone_no": phoneNo,
      "address": address,
      "opening_balance": balance,
      "photo": await MultipartFile.fromFile(
        supplierLogo!,
        filename: supplierLogo.split('/').last,
      )
    });

    var response = await BaseClient.postData(
      token: token,
      api: NetWorkStrings.addSupplier,
      body: formData,
    );
    return response;
  }

  static Future<dynamic> update({
    required String categoryName,
    required int supplierId,
    required String token,
  }) async {


    var response = await BaseClient.postData(
      token: token,
      api: "${NetWorkStrings.updateSupplier}$supplierId",
      body: {
        "name": categoryName,
      },
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
    return response;
  }
}
