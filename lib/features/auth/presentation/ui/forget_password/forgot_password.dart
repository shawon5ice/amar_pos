import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_glass_morf_field.dart';
import '../../../../../core/widgets/field_title.dart';
import '../../../../../core/widgets/methods/helper_methods.dart';
import '../../controller/auth_controller.dart';
import '../login_screen.dart';
import '../widgets/auth_header.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = '/forgot_password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController passwordController;
  late final TextEditingController phoneCon;

  //registration
  late final TextEditingController confirmPassword;
  final TextEditingController pinPutController = TextEditingController();

  String? businessLogo;
  String? ownerPhoto;

  Timer? _timer;
  int _time = 59;

  void startTimer() {

    _time = 59;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_time == 0) {
        setState(() {
          timer.cancel();
          // _authCon.instance.verifyPhoneNumber(phoneNo);
        });
      } else {
        setState(() {
          _time--;
        });
      }
    });
  }

  final FocusNode pinPutFocusNode = FocusNode();

  late FocusNode passwordFocus;
  late FocusNode phoneFocus;
  late FocusNode confirmPasswordFocusNode;

  final formKey = GlobalKey<FormState>();
  AuthController controller = Get.find();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // or any color you use
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light, // For iOS
    ));
    passwordController = TextEditingController();
    confirmPassword = TextEditingController();
    phoneCon = TextEditingController();
    passwordFocus = FocusNode();
    phoneFocus = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    super.initState();
  }

  Future clearFields() async {
    controller.businessLogo = null;
    controller.ownerPhoto = null;
    // emailController.clear();
    // passwordController.clear();
    confirmPassword.clear();
    ownerPhoto = '';
    businessLogo = '';
    controller.forgotPasswordStep.value = ForgotPasswordStep.enterPhone;
    controller.showSignUpView = false;
  }

  Future<bool> validate() async {
    if (passwordController.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter a password");
      passwordFocus.requestFocus(); // fix here too
      return false;
    } else if (confirmPassword.text.isEmpty) {
      Methods.showSnackbar(msg: "Please retype your password");
      confirmPasswordFocusNode.requestFocus(); // fix here too
      return false;
    } else if (passwordController.text != confirmPassword.text) {
      Methods.showSnackbar(msg: "Please match both password");
      confirmPasswordFocusNode.requestFocus(); // fix here too
      return false;
    }
    return true;
  }

  Future<bool> validatePhoneNumber() async {
    if (phoneCon.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your phone number");
      phoneFocus.requestFocus();
      return false;
    } else if (!phoneCon.text.toString().isPhoneNumber) {
      Methods.showSnackbar(msg: "Please enter a valid phone number");
      phoneFocus.requestFocus();
      return false;
    }
    return true;
  }

  dio.FormData formData = dio.FormData();

  Future<dio.FormData> prepareData() async {
    final Map<String, dynamic> fields = {
      "phone": phoneCon.text,
      "password": passwordController.text,
      "password_confirmation": confirmPassword.text,
    };

    return dio.FormData.fromMap({
      ...fields,
    });
  }


  @override
  void dispose() {
    clearFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (v) async {
        await clearFields();
        Get.back();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.scaffoldBackground,
        ),
        // backgroundColor: Colors.blue.shade50,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: LayoutBuilder(
              builder: (context,constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context)
                          .viewInsets
                          .bottom, // ensures view adjusts for keyboard
                    ),
                    child: GetBuilder<AuthController>(
                        id: 'forgot_password',
                        builder: (controller) {
                          return Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: constraints.maxHeight/6-50,bottom:  100),
                                  child: Center(
                                    child: Image.asset(
                                      AppAssets.amarPosLogo,
                                      height: 110,
                                      width: 200,
                                    ),
                                  ),
                                ),
                                // Obx(() => AuthHeader(title: "Sign In", error: controller.message.value,),),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (!controller.showChangePasswordInputFields)
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            const FieldTitle(
                                              "Phone number",
                                            ),
                                            addH(4),
                                            CustomGlassMorfTextField(
                                              enabledFlag:
                                              controller.forgotPasswordStep.value ==
                                                  ForgotPasswordStep.enterPhone || controller.forgotPasswordStep.value == ForgotPasswordStep.otpSendingFailed
                                                  ? null
                                                  : false,
                                              textCon: phoneCon,
                                              hintText: 'Enter phone number',
                                              txtSize: 14.sp,
                                              inputType: TextInputType.phone,
                                              focusNode: phoneFocus,
                                              errorText:
                                              "⚠️ Please insert your phone number!",
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  phoneFocus.requestFocus();
                                                  return '⚠️ Please insert your phone number!';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      if (controller.showChangePasswordInputFields)
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            buildField(
                                              title: 'Password',
                                              con: passwordController,
                                              focus: passwordFocus,
                                              isPassField: true,
                                              isMandatory: true,
                                            ),
                                            buildField(
                                              title: 'Confirm Password',
                                              con: confirmPassword,
                                              focus: confirmPasswordFocusNode,
                                              isPassField: true,
                                              isMandatory: true,
                                            ),
                                          ],
                                        ),
                                      Obx(() {
                                        if (controller.forgotPasswordStep.value ==
                                            ForgotPasswordStep.otpSent ||
                                            controller.forgotPasswordStep.value ==
                                                ForgotPasswordStep.verifyingOtp ||
                                            controller.forgotPasswordStep.value ==
                                                ForgotPasswordStep.otpVerifyingFailed) {
                                          return Column(
                                            children: [
                                              addH(12),
                                              Pinput(
                                                length: 6,
                                                // onSubmit: (String pin) => _showSnackBar(pin, context),
                                                focusNode: pinPutFocusNode,
                                                controller: pinPutController,
                                                // submittedFieldDecoration:
                                                //     _pinPutDecoration.copyWith(
                                                //   borderRadius: BorderRadius.circular(20.0),
                                                // ),
                                                // selectedFieldDecoration: _pinPutDecoration,
                                                // followingFieldDecoration:
                                                //     _pinPutDecoration.copyWith(
                                                //   borderRadius: BorderRadius.circular(5.0),
                                                //   border: Border.all(
                                                //     color:
                                                //         Colors.deepPurpleAccent.withOpacity(.5),
                                                //   ),
                                                // ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15, top: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    _time == 0
                                                        ? TextButton(
                                                      onPressed: () async {
                                                        pinPutController
                                                            .clear();
                                                        bool check =
                                                        await validatePhoneNumber();
                                                        if (check) {
                                                          bool sent =
                                                          await controller
                                                              .sendOTP(phoneCon.text.trim(),checkPlace: 3, isForgotPassword: true);
                                                          if (sent) {
                                                            startTimer();
                                                          }
                                                        }
                                                        // Re-send Button Function
                                                        controller.update([
                                                          'register_screen'
                                                        ]);
                                                      },
                                                      style: ButtonStyle(
                                                        elevation:
                                                        WidgetStateProperty
                                                            .all(0),
                                                        backgroundColor:
                                                        WidgetStateProperty
                                                            .all(
                                                          AppColors.primary,
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "Re-send",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                        : RichText(
                                                      text: TextSpan(
                                                        text: 'Re-send in ',
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: '00:$_time',
                                                            style: const TextStyle(
                                                              color: Colors.red,
                                                              fontFamily:
                                                              'Poppins',
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          const TextSpan(
                                                            text: ' sec',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontFamily:
                                                              'Poppins',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      }),
                                      addH(24),
                                      Obx(() {
                                        final step = controller.forgotPasswordStep.value;
                                        // final formValid = formKey.currentState?.validate() ?? false;

                                        if (step == ForgotPasswordStep.sendingOtp ||
                                            step == ForgotPasswordStep.verifyingOtp ||
                                            step == ForgotPasswordStep.forgettingPassword) {
                                          return CustomBtn(
                                            btnColor: Colors.grey,
                                            onPressedFn: () {},
                                            btnTxt: 'Processing...',
                                            txtSize: 18,
                                          );
                                        }

                                        if (step == ForgotPasswordStep.otpSent) {
                                          return CustomBtn(
                                            btnColor: AppColors.primary,
                                            onPressedFn: () => controller
                                                .verifyOTP(pinPutController.text,phoneCon.text.trim(),checkPlace: 3,isForgotPassword: true),
                                            btnTxt: 'Verify OTP',
                                            txtSize: 18,
                                          );
                                        }

                                        if (step == ForgotPasswordStep.otpVerified) {
                                          return CustomBtn(
                                            btnTxt: "Change Password",
                                            btnColor: AppColors.primary,
                                            onPressedFn: () async {
                                              bool check = await validate();
                                              if (check) {
                                                var req = await prepareData();
                                                controller.changePassword(
                                                    req
                                                );
                                              } else {
                                                return;
                                              }
                                            },
                                          );
                                        }

                                        if (step == ForgotPasswordStep.forgetPasswordSuccess) {
                                          _timer?.cancel();
                                          Future.delayed(const Duration(seconds: 1), () {
                                            Get.offAllNamed(LoginScreen.routeName);
                                          });
                                          return CustomBtn(
                                            btnTxt: "Password Changed Successfully",
                                            btnColor: Colors.blue,
                                            onPressedFn: () {},
                                          );
                                        }

                                        if (step == ForgotPasswordStep.otpSendingFailed ||
                                            step == ForgotPasswordStep.otpVerifyingFailed ||
                                            step == ForgotPasswordStep.forgetPasswordFailed) {
                                          return CustomBtn(
                                            btnTxt: "Try Again",
                                            btnColor: AppColors.error,
                                            onPressedFn: () async {
                                              if (step == ForgotPasswordStep.otpSendingFailed) {
                                                bool check =
                                                await validatePhoneNumber();
                                                if (check) {
                                                  bool sent =
                                                  await controller.sendOTP(phoneCon.text.trim(),checkPlace: 3,isForgotPassword: true);
                                                  if (sent) {
                                                    startTimer();
                                                  }
                                                }
                                              } else if (step ==
                                                  ForgotPasswordStep.otpVerifyingFailed) {
                                                controller
                                                    .verifyOTP(pinPutController.text,phoneCon.text.trim(),checkPlace: 3,isForgotPassword: true);
                                              } else if (step ==
                                                  ForgotPasswordStep.forgetPasswordFailed) {
                                                bool check = await validate();
                                                if (check) {
                                                  var req = await prepareData();
                                                  controller.changePassword(
                                                      req
                                                  );
                                                } else {
                                                  return;
                                                }
                                              }
                                            },
                                          );
                                        }

                                        return CustomBtn(
                                          btnTxt: "Get OTP",
                                          btnColor: AppColors.accent,
                                          onPressedFn: () async {
                                            bool check = await validatePhoneNumber();
                                            if (check) {
                                              bool sent = await controller.sendOTP(phoneCon.text.trim(),checkPlace: 3,isForgotPassword: true);
                                              if (sent) {
                                                startTimer();
                                              }
                                            }
                                          },
                                        );
                                      })
                                    ],
                                  ),
                                ),
                                addH(0)
                              ],
                            ),
                          );
                        }),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  Text buildFieldTitle(String title) {
    return Text(
      title,
      style: Get.context?.textTheme.titleSmall,
    );
  }

  Widget buildField({
    required String title,
    required TextEditingController con,
    required FocusNode focus,
    bool? isMandatory,
    bool? isPassField,
    int? maxLine,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMandatory != null ? RichFieldTitle(text: title) : FieldTitle(title),
        addH(4),
        CustomGlassMorfTextField(
          textCon: con,
          hintText: 'Enter $title',
          txtSize: 14.sp,
          isPassField: isPassField != null ? true : null,
          inputType: TextInputType.text,
          focusNode: focus,
          maxLine: maxLine ?? 1,
          errorText: isMandatory != null ? "⚠️ Please insert $title" : null,
          validator: isMandatory != null
              ? (value) {
            if (value == null || value.isEmpty) {
              focus.requestFocus();
              return '⚠️ Please insert $title';
            }
            return null;
          }
              : null,
        ),
        addH(8),
      ],
    );
  }
}