import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/profile/data/models/profie_details_response_model.dart';
import 'package:amar_pos/features/profile/data/profile_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/network/helpers/error_extractor.dart';
import '../../../core/widgets/methods/helper_methods.dart';
import '../../auth/data/model/hive/login_data.dart';
import '../../auth/data/model/hive/login_data_helper.dart';


enum ChangePasswordStep {
  sendOTP,
  sendingOtp,
  otpSent,
  otpSendingFailed,
  verifyingOtp,
  changingPassword,
  changingPasswordFailed,
  passwordChanged,
  otpVerified,
  otpVerifyingFailed,
}


class ProfileController extends GetxController {
  LoginData? loginData = LoginDataBoxManager().loginData;
  final changePasswordStep = ChangePasswordStep.sendOTP.obs;
  bool isProfileDetailsLoading = false;
  ProfileDetailsResponseModel? profileDetailsResponseModel;

  Future<void> getProfileDetails() async {
    isProfileDetailsLoading = true;
    update([
      'profile_details',
    ]);

    try {
      var response = await ProfileService.getProfileDetails(
        usrToken: loginData!.token,
      );

      if (response != null) {
        profileDetailsResponseModel =
            ProfileDetailsResponseModel.fromJson(response);
        logger.i(response);
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isProfileDetailsLoading = false;
      update([
        'profile_details',
      ]);
    }
  }

  String? photo;

  Future<bool> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      if (photo != null) {
        photo = result.files.single.path;
      } else {
        photo = result.files.single.path;
      }
      update(['profile_picture']);
    }
    return true;
  }



  bool isSavingChangesLoading = false;
  Future saveProfileChanges(var formData) async {
    isSavingChangesLoading = true;
    update(['profile_details']);
    try {
      RandomLottieLoader.show();
      var response = await ProfileService.saveProfileChanges(
        usrToken: loginData!.token,
        formData: formData,
      );

      update(['register_screen']);
      if (response['success']) {
        DrawerMenuController drawerController = Get.find();

        profileDetailsResponseModel = ProfileDetailsResponseModel.fromJson(response);

        drawerController.manager.loginData!.photo = profileDetailsResponseModel!.data.photo;
        drawerController.manager.loginData!.address = profileDetailsResponseModel!.data.address;
        drawerController.manager.loginData!.name = profileDetailsResponseModel!.data.name;
        drawerController.manager.loginData!.email = profileDetailsResponseModel!.data.email;
        drawerController.manager.loginData!.phone = profileDetailsResponseModel!.data.phone;
        drawerController.update(['profile_picture']);
        Methods.showSnackbar(msg: response['message'], isSuccess: true);
      } else {
        if (response['errors'] is Map<String, dynamic>) {
          List<String> errors = ErrorExtractor.extractErrorMessages(response);
          logger.i(errors);
          String message = "";
          for (int i = 0; i < errors.length; i++) {
            message +=
                "${i + 1}. ${errors[i]} ${i < errors.length ? "\n" : ''}";
          }
          Methods.showSnackbar(msg: message);
        } else {
          Methods.showSnackbar(msg: response['message']);
        }
      }
    } catch (e) {
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    } finally {
      // Methods.hideLoading();
      RandomLottieLoader.hide();
      update(['profile_details']);
    }
  }

  Future updateProfilePhoto(var formData) async {
    isSavingChangesLoading = true;
    update(['profile_details']);
    try {
      RandomLottieLoader.show();
      var response = await ProfileService.updateProfilePhoto(
        usrToken: loginData!.token,
        formData: formData,
      );

      update(['register_screen']);
      if (response['success']) {
        logger.i(response);
        DrawerMenuController drawerController = Get.find();

        profileDetailsResponseModel = ProfileDetailsResponseModel.fromJson(response);
        drawerController.manager.loginData!.photo = profileDetailsResponseModel!.data.photo;
        drawerController.update(['profile_picture']);
        // loginData!.photo =
        // loginData!.address = profileDetailsResponseModel!.data.address;
        // loginData!.name = profileDetailsResponseModel!.data.name;
        // loginData!.email = profileDetailsResponseModel!.data.email;
        // loginData!.phone = profileDetailsResponseModel!.data.phone;
        Methods.showSnackbar(msg: response['message'], isSuccess: true);

      } else {
        if (response['errors'] is Map<String, dynamic>) {
          List<String> errors = ErrorExtractor.extractErrorMessages(response);
          logger.i(errors);
          String message = "";
          for (int i = 0; i < errors.length; i++) {
            message +=
            "${i + 1}. ${errors[i]} ${i < errors.length ? "\n" : ''}";
          }
          Methods.showSnackbar(msg: message);
        } else {
          Methods.showSnackbar(msg: response['message']);
        }
      }
    } catch (e) {
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    } finally {
      // Methods.hideLoading();
      RandomLottieLoader.hide();
      update(['profile_details']);
    }
  }

  //Change Password
  Future<bool> sendOTP(
      String oldPassword,
      String password,) async {
    changePasswordStep.value = ChangePasswordStep.sendingOtp;
    Methods.showLoading();
    try {
      var response = await ProfileService.sendOTP(
        usrToken: loginData!.token,
        phoneNumber: loginData!.phone,
        oldPassword: oldPassword,
        newPassword: password
      );

      update(['register_screen']);
      if(response['success']){
        changePasswordStep.value = ChangePasswordStep.otpSent;
        Methods.showSnackbar(msg: response['message'],isSuccess: true);
        return true;
      }else{
        changePasswordStep.value = ChangePasswordStep.otpSendingFailed;
        Methods.showSnackbar(msg: response['message']);
      }
    } catch(e){
      changePasswordStep.value = ChangePasswordStep.otpSendingFailed;
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }finally {
      Methods.hideLoading();
      update(['register_screen']);
    }
    return false;
  }

  Future verifyOTP(String otp,String oldPassword, String newPassword) async {
    if(otp.isEmpty && otp.length != 6){
      Methods.showSnackbar(msg: "Please enter valid OTP");
      return;
    }
    changePasswordStep.value = ChangePasswordStep.verifyingOtp;
    Methods.showLoading();
    try {
      var response = await ProfileService.verifyOTP(
        phoneNumber: loginData!.phone,
        usrToken: loginData!.token,
        otp: otp,
      );

      update(['register_screen']);
      if(response['success']){
        changePasswordStep.value = ChangePasswordStep.otpVerified;
        Methods.showSnackbar(msg: response['message'],isSuccess: true);
        changePassword(oldPassword, newPassword);
      }else{
        changePasswordStep.value = ChangePasswordStep.otpVerifyingFailed;
        Methods.showSnackbar(msg: response['message']);
      }
    } catch(e){
      changePasswordStep.value = ChangePasswordStep.otpVerifyingFailed;
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }finally {
      Methods.hideLoading();
      update(['register_screen']);
    }
  }

  Future changePassword(String oldPassword,String newPassword) async {

    changePasswordStep.value = ChangePasswordStep.changingPassword;
    Methods.showLoading();
    try {
      var response = await ProfileService.changePassword(
        usrToken: loginData!.token,
        newPassword: newPassword,
        oldPassword: oldPassword,
      );

      update(['register_screen']);
      if(response['success']){
        changePasswordStep.value = ChangePasswordStep.passwordChanged;

        Methods.showSnackbar(msg: response['message'],isSuccess: true);
      }else{
        changePasswordStep.value = ChangePasswordStep.otpVerifyingFailed;
        Methods.showSnackbar(msg: response['message']);
      }
    } catch(e){
      changePasswordStep.value = ChangePasswordStep.otpVerifyingFailed;
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }finally {
      Methods.hideLoading();
      update(['register_screen']);
    }
  }
}
