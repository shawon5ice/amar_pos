import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';
import 'package:dio/dio.dart';

class OutletService {
  static Future<dynamic> getAll({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllOutlet,
    );
    return response;
  }

  static Future<dynamic> store({
    String? name,
    String? shortCode,
    required String token,
    String? nagad,
    String? bkash,
    String? phone,
    String? address,
  }) async {
    FormData formData = FormData.fromMap({
      'name': name,
      'short_code': shortCode,
      'phone': phone,
      'address': address,
      'nagad' : nagad,
      'bkash': bkash
    });

    var response = await BaseClient.postData(
      token: token,
      api: NetWorkStrings.addOutlet,
      body: formData,
    );
    return response;
  }

  static Future<dynamic> update({
    required int outletId,
    String? name,
    String? shortCode,
    required String token,
    String? nagad,
    String? bkash,
    String? phone,
    String? address,
  }) async {
    FormData formData = FormData.fromMap({
      'name': name,
      'short_code': shortCode,
      'phone': phone,
      'address': address,
      'nagad' : nagad,
      'bkash': bkash
    });

    var response = await BaseClient.postData(
      token: token,
      api: "${NetWorkStrings.updateOutlet}$outletId",
      body: formData,
    );
    return response;
  }

  static Future<dynamic> delete({
    required int outletId,
    required String token,
  }) async {
    var response = await BaseClient.deleteData(
      token: token,
      api: "${NetWorkStrings.deleteOutlet}$outletId",
    );
    return response;
  }

  static Future<dynamic> changeStatus({
    required int outletId,
    required String token,
  }) async {

    var response = await BaseClient.getData(
      token: token,
      api: "${NetWorkStrings.changeStatusOfOutlet}$outletId",
    );
    return response;
  }

}
