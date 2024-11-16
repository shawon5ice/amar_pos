import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';

class CategoryService {
  static Future<dynamic> get({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllCategories,
    );
    return response;
  }

  static Future<dynamic> store({
    required String categoryName,
    required String token,
  }) async {

    var response = await BaseClient.postData(
      token: token,
      api: NetWorkStrings.addCategory,
      body: {
        "name": categoryName,
      },
    );
    return response;
  }

  static Future<dynamic> update({
    required String categoryName,
    required int brandId,
    required String token,
  }) async {


    var response = await BaseClient.postData(
      token: token,
      api: "${NetWorkStrings.updateCategory}$brandId",
      body: {
        "name": categoryName,
      },
    );
    return response;
  }

  static Future<dynamic> delete({
    required int categoryId,
    required String token,
  }) async {

    var response = await BaseClient.deleteData(
      token: token,
      api: "${NetWorkStrings.deleteCategory}$categoryId",
    );
    return response;
  }
}
