import 'dart:convert';

import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/features/auth/data/model/sign_in_response.dart' as network;
import 'package:amar_pos/features/drawer/main_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/data/preference.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../data/model/hive/login_data.dart';
import '../../data/model/hive/login_data_helper.dart';
import '../../data/services/auth_remote_data_service.dart';

enum AuthStep {
  enterPhone,
  sendingOtp,
  otpSent,
  otpSendingFailed,
  verifyingOtp,
  otpVerified,
  otpVerifyingFailed,
  signingUp,
  signUpSuccess,
  signingUpFailed,
}

enum ForgotPasswordStep {
  enterPhone,
  sendingOtp,
  otpSent,
  otpSendingFailed,
  verifyingOtp,
  otpVerified,
  otpVerifyingFailed,
  forgettingPassword,
  forgetPasswordFailed,
  forgetPasswordSuccess,
}

class AuthController extends GetxController{
  RxBool isLoggedIn = false.obs;
  RxBool loading = false.obs;
  final authStep = AuthStep.enterPhone.obs;
  final forgotPasswordStep = ForgotPasswordStep.enterPhone.obs;
  network.SignInResponse? signInResponse;
  // UserInfo? userInfo;
  RxString message = ''.obs;
  RxBool isLoggingIn = true.obs;

  bool rememberMeFlag  = false;

  bool showSignUpView = false;
  bool showChangePasswordInputFields = false;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneCon;


  String? businessLogo;
  String? ownerPhoto;

  final FocusNode pinPutFocusNode = FocusNode();

  late FocusNode emailFocus;
  late FocusNode passwordFocus;


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

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneCon = TextEditingController();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    initializeRememberMe();
    super.onInit();
  }

  initializeRememberMe() async {
    await Future.delayed(Duration(milliseconds: 100)); // slight delay may help in some edge UI race cases
    if (Preference.getRememberMeFlag()) {
      final email = Preference.getLoginEmail();
      final pass = Preference.getLoginPass();
      if (email.isNotEmpty && pass.isNotEmpty) {
        emailController.text = email;
        passwordController.text = pass;
        rememberMeFlag = true;
        update(['remember_me']);
      }
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }
  void handleRememberMe({bool? remember}){
    rememberMeFlag = remember ?? !rememberMeFlag;
    Preference.setRememberMeFlag(rememberMeFlag);
    update(['remember_me']);
  }

  void saveOrNot() {
    if (rememberMeFlag) {
      Preference.setLoginEmail(emailController.text.trim());
      Preference.setLoginPass(passwordController.text.trim());
    } else {
      Preference.setLoginEmail("");
      Preference.setLoginPass("");
    }
  }


  Future<void> selectFile({bool? ownerLogo}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,

    );
    if (result != null) {
      if(ownerLogo != null){
        ownerPhoto = result.files.single.path;
      }else{
        businessLogo = result.files.single.path;
      }
      update(['register_screen']);
    }
  }



  void signIn() async {
    isLoggedIn.value = false;
    FocusManager.instance.primaryFocus?.unfocus();
    message.value = '';
    loading(true);
    Methods.showLoading();

    try {
      var response = await AuthRemoteDataService.signIn(
        email: emailController.text.trim(),
        pass: passwordController.text.trim(),
      );

      if (response != null && !response['success']) {
        message.value = response['message'];
      }

      if (response['success']) {
        isLoggedIn(true);
        saveOrNot(); // ✅ only after success
        LoginDataBoxManager().loginData = LoginData.fromJson(response['data']);
        Preference.setLoggedInFlag(true);
      }

    } finally {
      if (message.isNotEmpty) {
        Methods.showSnackbar(msg: message.value, isSuccess: isLoggedIn.value ? true : null);
      }
      if (isLoggedIn.value) {
        Get.offAllNamed(MainPage.routeName);
      }
      loading(false);
      Methods.hideLoading();
    }
  }

  // Function to process Map data in the background
  Future<network.SignInResponse> processDataInBackground(Map<String, dynamic> data) async {
    return compute(_processData, data);
  }

// The actual processing logic
  network.SignInResponse _processData(Map<String, dynamic> data) {
    return network.SignInResponse.fromJson(data);
  }

// Example Usage
  void processLoginResponse(Map<String, dynamic> jsonResponse) async {
    try {
      network.SignInResponse userData = _processData(jsonResponse);
      print("User Token: ${userData.loginData.token}");
      print("Permissions Count: ${userData.loginData.permissions.length}");
    } catch (e) {
      print("Error parsing user data: $e");
    }
  }

  //Send OTP
  Future<bool> sendOTP(String phone, {int? checkPlace, bool? isForgotPassword}) async {
    if(isForgotPassword != null){
      forgotPasswordStep.value = ForgotPasswordStep.sendingOtp;
    }else{
      authStep.value = AuthStep.sendingOtp;
    }
    Methods.showLoading();
    try {
      var response = await AuthRemoteDataService.sendOTP(
        phoneNumber: phone,
        checkPlace: checkPlace,
      );

      update(['register_screen','forgot_password']);
      if(response['success']){
        if(isForgotPassword != null){
          forgotPasswordStep.value = ForgotPasswordStep.otpSent;
        }else{
          authStep.value = AuthStep.otpSent;
        }
        Methods.showSnackbar(msg: response['message'],isSuccess: true);
        return true;
      }else{
        if(isForgotPassword != null){
          forgotPasswordStep.value = ForgotPasswordStep.otpSendingFailed;
        }else{
          authStep.value = AuthStep.otpSendingFailed;
        }
        Methods.showSnackbar(msg: response['message']);
      }
    } catch(e){
      if(isForgotPassword != null){
        forgotPasswordStep.value = ForgotPasswordStep.otpSendingFailed;
      }else{
        authStep.value = AuthStep.otpSendingFailed;
      }
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }finally {
      Methods.hideLoading();
      update(['register_screen','forgot_password']);
    }
    return false;
  }

  Future verifyOTP(String otp, String phone,{int? checkPlace,bool? isForgotPassword}) async {
    if(otp.isEmpty && otp.length != 6){
      Methods.showSnackbar(msg: "Please enter valid OTP");
      return;
    }

    if(isForgotPassword != null){
      forgotPasswordStep.value = ForgotPasswordStep.verifyingOtp;
    }else{
      authStep.value = AuthStep.verifyingOtp;
    }
    Methods.showLoading();
    try {
      var response = await AuthRemoteDataService.verifyOTP(
        phoneNumber: phone,
        otp: otp,
        checkPlace: checkPlace
      );

      update(['register_screen','forgot_password']);
      if(response['success']){
        if(isForgotPassword != null){
          forgotPasswordStep.value = ForgotPasswordStep.otpVerified;
          showChangePasswordInputFields = true;
        }else{
          authStep.value = AuthStep.otpVerified;
          showSignUpView = true;
        }
        Methods.showSnackbar(msg: response['message'],isSuccess: true);
      }else{
        if(isForgotPassword != null){
          forgotPasswordStep.value = ForgotPasswordStep.otpVerifyingFailed;
        }else{
          authStep.value = AuthStep.otpVerifyingFailed;
        }
        Methods.showSnackbar(msg: response['message']);
      }
    } catch(e){
      if(isForgotPassword != null){
        forgotPasswordStep.value = ForgotPasswordStep.otpVerifyingFailed;
      }else{
        authStep.value = AuthStep.otpVerifyingFailed;
      }

      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }finally {
      Methods.hideLoading();
      update(['register_screen','forgot_password']);
    }
  }





  Future signUp(var formData) async {
    authStep.value = AuthStep.signingUp;
    // Methods.showLoading();
    try {
      var response = await AuthRemoteDataService.signUp(
        formData
      );

      update(['register_screen']);
      if(response['success']){
        authStep.value = AuthStep.signUpSuccess;
        Methods.showSnackbar(msg: response['message'],isSuccess: true);
      }else{
        authStep.value = AuthStep.signingUpFailed;
        if(response['errors'] is Map<String, dynamic>){
          List<String> errors = ErrorExtractor.extractErrorMessages(response);
          logger.i(errors);
          String message = "";
          for (int i = 0; i<errors.length; i++) {
            message += "${i+1}. ${errors[i]} ${i<errors.length?"\n":''}";
          }
          Methods.showSnackbar(msg: message);
        }else{
          Methods.showSnackbar(msg: response['message']);
        }

      }
    } catch(e){
      authStep.value = AuthStep.signingUpFailed;
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }finally {
      // Methods.hideLoading();
      update(['register_screen']);
    }
  }


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


  Future changePassword(var formData) async {
    forgotPasswordStep.value = ForgotPasswordStep.forgettingPassword;
    // Methods.showLoading();
    try {
      var response = await AuthRemoteDataService.changePassword(
          formData
      );

      update(['forgot_password']);
      if(response['success']){
        forgotPasswordStep.value = ForgotPasswordStep.forgetPasswordSuccess;
        Methods.showSnackbar(msg: response['message'],isSuccess: true);
      }else{
        forgotPasswordStep.value = ForgotPasswordStep.forgetPasswordFailed;
        if(response['errors'] is Map<String, dynamic>){
          List<String> errors = ErrorExtractor.extractErrorMessages(response);
          logger.i(errors);
          String message = "";
          for (int i = 0; i<errors.length; i++) {
            message += "${i+1}. ${errors[i]} ${i<errors.length?"\n":''}";
          }
          Methods.showSnackbar(msg: message);
        }else{
          Methods.showSnackbar(msg: response['message']);
        }

      }
    } catch(e){
      forgotPasswordStep.value = ForgotPasswordStep.forgetPasswordFailed;
      Methods.showSnackbar(msg: AppStrings.kWentWrong);
    }finally {
      // Methods.hideLoading();
      update(['forgot_password']);
    }
  }
}

