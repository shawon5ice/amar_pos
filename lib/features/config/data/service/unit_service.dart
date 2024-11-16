import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';

class UnitService {
  static Future<dynamic> get({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: NetWorkStrings.getAllUnits,
    );
    return response;
  }
}
