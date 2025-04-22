import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/features/profile/data/models/profie_details_response_model.dart';
import 'package:amar_pos/features/profile/data/profile_service.dart';
import 'package:get/get.dart';

import '../../auth/data/model/hive/login_data.dart';
import '../../auth/data/model/hive/login_data_helper.dart';

class ProfileController extends GetxController{
  LoginData? loginData = LoginDataBoxManager().loginData;



  bool isProfileDetailsLoading = false;
  ProfileDetailsResponseModel? profileDetailsResponseModel;

  Future<void> getProfileDetails() async {
    isProfileDetailsLoading = true;
    update(['profile_details',]);

    try {
      var response = await ProfileService.getProfileDetails(
        usrToken: loginData!.token,);

      if (response != null) {
        profileDetailsResponseModel = ProfileDetailsResponseModel.fromJson(response);
        logger.i(response);
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isProfileDetailsLoading = false;
      update(['profile_details',]);
    }
  }
}