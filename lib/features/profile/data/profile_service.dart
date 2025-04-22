import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class ProfileService {
  static Future<dynamic> getProfileDetails({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: 'business_user/get-profile-details',
    );
    return response;
  }
}
