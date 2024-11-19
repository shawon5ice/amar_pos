import 'dart:convert';

import 'package:amar_pos/features/auth/data/model/sign_in_response.dart' as network;
import 'package:amar_pos/features/drawer/main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/data/preference.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../data/model/hive/login_data.dart';
import '../../data/model/hive/login_data_helper.dart';
import '../../data/services/auth_remote_data_service.dart';

class AuthController extends GetxController{
  RxBool isLoggedIn = false.obs;
  RxBool loading = false.obs;

  network.SignInResponse? signInResponse;
  // UserInfo? userInfo;
  RxString message = ''.obs;
  RxBool isLoggingIn = true.obs;

  bool rememberMeFlag  = false;

  late final formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneCon;

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
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneCon = TextEditingController();

    emailFocus = FocusNode();
    passwordFocus = FocusNode();

    if (Preference.getRememberMeFlag()) {
      emailController.text = Preference.getLoginEmail();
      passwordController.text = Preference.getLoginPass();
      rememberMeFlag = true;
      update(['remember_me']);
    }
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneCon.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();

    formKey = null;
    super.dispose();
  }
  void handleRememberMe({bool? remember}){
    rememberMeFlag = remember ?? !rememberMeFlag;
    update(['remember_me']);
  }

  void saveOrNot(){
    if(rememberMeFlag){
      Preference.setLoginEmail(emailController.text.trim());
      Preference.setLoginPass(passwordController.text.trim());
    }else{
      Preference.setLoginEmail("");
      Preference.setLoginPass("");
    }
  }

  void signIn() async {
    if(!formKey.currentState!.validate()){
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    saveOrNot();
    message.value = '';
    loading(true);
    Methods.showLoading();
    try {
      var response = await AuthRemoteDataService.signIn(
        email: emailController.text.trim(),
        pass: passwordController.text.trim(),
      );
      logger.i(response);
      if(response != null){
        message.value = response['message'];
      }
      if (response['success']) {
        // signInResponse = _processData(response);
        // userInfo = SignInResponseModel.fromJson(response).userInfo;
        isLoggedIn(true);
        LoginDataBoxManager().loginData = LoginData.fromJson(response['data']);

        Preference.setLoggedInFlag(true);
        // Preference.setLoginData(signInResponse!.loginData);

        logger.d(LoginDataBoxManager().loginData?.permissions.length);
      }
    } finally {
      if(message.isNotEmpty){
        Methods.showSnackbar(msg: message.value, isSuccess: isLoggedIn.value?true:null);
      }
      if(isLoggedIn.value){
        Get.toNamed(MainPage.routeName);
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


// late StreamSubscription _subscription;
// bool _isOffline = false;

// @override
// void initState() {
//   _emailFocus = FocusNode();
//   _passwordFocus = FocusNode();
//   if (Preference.getRememberMeFlag()) {
//     _emailController.text = Preference.getLoginEmail();
//     _passwordController.text = Preference.getLoginPass();
//     _rememberMeFlag = true;
//   }
//
//   _authCon.loading.listen((value) {
//     if (!value && _authCon.isLoggedIn.value) {
//       _authCon.isLoggedIn(false);
//       // UserInfo userInfo = Preference.getUserInfo();
//       // logger.i("ID:${userInfo.departmentId}");
//       // if(userInfo.departmentId == 8){
//       //   Future.delayed(
//       //     const Duration(milliseconds: 100),
//       //         () => Get.offAllNamed(HomeScreen.routeName),
//       //   );
//       // }else{
//       //   Future.delayed(
//       //     const Duration(milliseconds: 100),
//       //         () => Get.offAllNamed(HRMScreen.routeName),
//       //   );
//       // }
//     }
//   });
//
//
//   // _subscription = InternetConnectionChecker().onStatusChange.listen((status) {
//   //   final hasInternet = status == InternetConnectionStatus.connected;
//   //   setState(() {
//   //     isOffline = !hasInternet;
//   //   });
//   // });
//
//   super.initState();
// }
