import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/network_strings.dart';

class HomeScreenService {
  static Future<dynamic>getPermissions({
  required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: "get-user-permissions",);
    return response;
  }
}
