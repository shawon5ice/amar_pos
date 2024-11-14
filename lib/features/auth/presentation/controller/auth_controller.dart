import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/data/preference.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../data/services/auth_remote_data_service.dart';

class AuthController extends GetxController{
  RxBool isLoggedIn = false.obs;
  RxBool loading = false.obs;
  // UserInfo? userInfo;
  String message = '';
  RxBool isLoggingIn = true.obs;
  final TextEditingController phoneCon = TextEditingController();
  RxBool otpSend = false.obs;
  RxBool verificationDone = false.obs;
  bool fromChangePassword = false;


  RxList<String> imgPaths = <String>[
    '',
    '',
    '',
    '',
    '',
  ].obs;

  void signIn({
    required String email,
    required String password,
  }) async {
    message = '';
    loading(true);
    Methods.showLoading();
    try {
      var response = await AuthRemoteDataService.signIn(
        email: email,
        pass: password,
      );
      logger.i(response);
      if(response != null){
        message = response['message'];
      }
      if (response['success']) {
        // userInfo = SignInResponseModel.fromJson(response).userInfo;
        isLoggedIn(true);
        Preference.setLoggedInFlag(true);
        // Preference.setUserInfo(userInfo!);
      }
    } finally {
      if(message.isNotEmpty){
        Methods.showSnackbar(msg: message, isSuccess: isLoggedIn.value?true:null);
      }
      loading(false);
      Methods.hideLoading();
    }
  }

  //Send OTP
  // Future sendOTP({
  //   required bool isForVerification,
  //   required String otp,
  // }) async {
  //   isLoggingIn(true);
  //   Methods.showLoading();
  //   try {
  //     var response = await AuthRemoteDataService.sendOTP(
  //       phoneNumber: phoneCon.text.trim(),
  //       isForVerification: isForVerification,
  //       otp: otp,
  //     );
  //
  //     if(response['success'] && !isForVerification){
  //       otpSend(true);
  //     }else if(response['success'] && isForVerification){
  //       verificationDone(true);
  //     }
  //     update(['forgot_password_view']);
  //     if(response['success']){
  //       Methods.showSnackbar(msg: response['message'],isSuccess: true);
  //     }else{
  //       Methods.showSnackbar(msg: response['message']);
  //     }
  //   } catch(e){
  //     Methods.showSnackbar(msg: AppStrings.kWentWrong);
  //   }finally {
  //     Methods.hideLoading();
  //     update(['forgot_password_view']);
  //   }
  // }


  //Send password
  // Future sendPassword({
  //   required String password,
  //   required String c_password,
  // }) async {
  //   isLoggingIn(true);
  //   Methods.showLoading();
  //   try {
  //     var response = await AuthRemoteDataService.sendPasswordToChange(
  //         phoneNumber: phoneCon.text.trim(),
  //         password: password,
  //         c_password: c_password
  //     );
  //
  //     if(response['success']){
  //       Methods.showSnackbar(msg: response["message"],isSuccess: true);
  //       return true;
  //     }else{
  //       Methods.showSnackbar(msg: response["message"]);
  //       return false;
  //     }
  //   } catch(e){
  //     Methods.showSnackbar(msg: AppStrings.kWentWrong);
  //   }finally {
  //     Methods.hideLoading();
  //   }
  // }

  Future<void> pickImage(galleryFlag, index) async {
    XFile? image;
    try {
      if (galleryFlag) {
        image = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: 800,
          maxWidth: 600,
        );
      }
      if (image == null) return;
      // imgList.clear();
      // imgList.add(File(image.path));
      // var response = await SignUpService.uploadMedia(
      //   filePath: imgList.first.path,
      // );
      // imgList.clear();
      // imgPaths[index] = response["data"][0];
      imgPaths[index] = image.path;
      print(imgPaths[index]);
    } on PlatformException catch (e) {
      Get.snackbar(
        'Error Occured!',
        'Failed to pick image: $e',
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 300),
      );
    }
  }

  void showImgDialog(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    showGeneralDialog(
      context: Get.context!,
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Methods.buildDPAlertDialog2(
          onPressedFn: pickImage,
          ctx: context,
          indx: index,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

}