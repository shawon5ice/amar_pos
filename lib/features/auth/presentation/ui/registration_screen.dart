import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/auth/presentation/ui/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_btn.dart';
import '../../../../core/widgets/custom_glass_morf_field.dart';
import '../../../../core/widgets/dotted_border_painter.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../controller/auth_controller.dart';
import 'widgets/auth_header.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static String routeName = '/registration';

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final TextEditingController emailController;
  late final TextEditingController otpController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneCon;

  //registration
  late final TextEditingController businessName;
  late final TextEditingController businessSortCode;
  late final TextEditingController ownerName;
  late final TextEditingController confirmPassword;
  late final TextEditingController addressField;
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

  late FocusNode emailFocus;
  late FocusNode passwordFocus;
  late FocusNode phoneFocus;
  late FocusNode businessNameFocusNode;
  late FocusNode businessShortCodeFocusNode;
  late FocusNode ownerNameFocusNode;
  late FocusNode addressFocusNode;
  late FocusNode confirmPasswordFocusNode;

  final formKey = GlobalKey<FormState>();
  AuthController controller = Get.find();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPassword = TextEditingController();
    otpController = TextEditingController();
    phoneCon = TextEditingController();
    businessName = TextEditingController();
    businessSortCode = TextEditingController();
    ownerName = TextEditingController();
    addressField = TextEditingController();

    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    phoneFocus = FocusNode();
    businessNameFocusNode = FocusNode();
    businessShortCodeFocusNode = FocusNode();
    ownerNameFocusNode = FocusNode();
    addressFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    super.initState();
  }

  Future clearFields() async {
    businessName.clear();
    businessSortCode.clear();
    controller.businessLogo = null;
    controller.ownerPhoto = null;
    // emailController.clear();
    // passwordController.clear();
    confirmPassword.clear();
    addressField.clear();
    ownerName.clear();
    ownerPhoto = '';
    businessLogo = '';
    controller.authStep.value = AuthStep.enterPhone;
    controller.showSignUpView = false;
  }

  Future<bool> validate() async {
    if (businessName.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your business name");
      businessNameFocusNode.requestFocus();
      return false;
    } else if (businessSortCode.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your business short code");
      businessShortCodeFocusNode.requestFocus();
      return false;
    } else if (ownerName.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your name");
      ownerNameFocusNode.requestFocus(); // fix here too
      return false;
    } else if (passwordController.text.isEmpty) {
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
    } else if (addressField.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your business address");
      addressFocusNode.requestFocus(); // fix here too
      return false;
    }
    return true;
  }

  Future<bool> validatePhoneNumber() async {
    final phoneRegex = RegExp(AppStrings.bdPhoneNumber);
    if (phoneCon.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your phone number");
      phoneFocus.requestFocus();
      return false;
    } else if (!phoneRegex.hasMatch(phoneCon.text)) {
      Methods.showSnackbar(msg: "Please enter a valid Bangladeshi phone number");
      phoneFocus.requestFocus();
      return false;
    }
    return true;
  }

  dio.FormData formData = dio.FormData();

  Future<dio.FormData> prepareData() async {
    final Map<String, dynamic> fields = {
      "business_name": businessName.text,
      "short_code": businessSortCode.text,
      "address": addressField.text,
      "email": emailController.text,
      "name": ownerName.text,
      "phone": phoneCon.text,
      "password": passwordController.text,
      "password_confirmation": confirmPassword.text,
    };

    final Map<String, dio.MultipartFile> fileMap = {};

    if (controller.businessLogo != null) {
      fileMap['business_logo'] = await dio.MultipartFile.fromFile(
        controller.businessLogo!,
      );
    }

    if (controller.ownerPhoto != null) {
      fileMap['photo'] = await dio.MultipartFile.fromFile(
        controller.ownerPhoto!,
      );
    }

    return dio.FormData.fromMap({
      ...fields,
      ...fileMap,
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
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 50,
            backgroundColor: AppColors.scaffoldBackground,
          ),
          // backgroundColor: Colors.blue.shade50,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: boxConstraints.maxHeight
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom, // ensures view adjusts for keyboard
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: boxConstraints.maxHeight/6-50,bottom:  48),
                            child: Center(
                              child: Image.asset(
                                AppAssets.amarPosLogo,
                                height: 110,
                                width: 200,
                              ),
                            ),
                          ),
                          GetBuilder<AuthController>(
                              id: 'register_screen',
                              builder: (controller) {
                                return Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                          child: Obx(
                                        () => Text(controller.message.value ?? '',
                                            style: context.textTheme.bodyMedium?.copyWith(
                                              color: AppColors.error,
                                            )),
                                      )),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // email title
                                            // Center(
                                            //   child: const Text(
                                            //     'Register to AMAR POS!',
                                            //     style: TextStyle(
                                            //         fontSize: 18,
                                            //         fontWeight: FontWeight.bold),
                                            //   ),
                                            // ),
                                            // addH(50),
                                            // email field
                                            if (!controller.showSignUpView)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FieldTitle(
                                                    "Phone number",
                                                    fontSize: context
                                                        .textTheme.titleSmall?.fontSize,
                                                  ),
                                                  addH(4),
                                                  CustomGlassMorfTextField(
                                                    enabledFlag: controller
                                                                    .authStep.value ==
                                                                AuthStep.enterPhone ||
                                                            controller.authStep.value ==
                                                                AuthStep.otpSendingFailed
                                                        ? null
                                                        : false,
                                                    textCon: phoneCon,
                                                    hintText: 'Enter phone number',
                                                    txtSize: 16.sp,
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
                                            if (controller.showSignUpView)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  buildField(
                                                      title: 'Business Name',
                                                      con: businessName,
                                                      focus: businessNameFocusNode,
                                                      isMandatory: true),
                                                  buildField(
                                                      title: 'Business Short Code',
                                                      con: businessSortCode,
                                                      focus: businessShortCodeFocusNode,
                                                      isMandatory: true),
                                                  buildField(
                                                      title: 'Owner Name',
                                                      con: ownerName,
                                                      focus: ownerNameFocusNode,
                                                      isMandatory: true),
                                                  buildField(
                                                    title: 'Email',
                                                    con: emailController,
                                                    focus: emailFocus,
                                                  ),
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
                                                  buildField(
                                                      title: 'Address',
                                                      con: addressField,
                                                      focus: addressFocusNode,
                                                      maxLine: 3),
                                                  addH(8.h),
                                                  const FieldTitle(
                                                    "Business Logo",
                                                  ),
                                                  addH(8.h),
                                                  InkWell(
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(8)),
                                                    onTap: () => controller.selectFile(),
                                                    child: CustomPaint(
                                                      painter: DottedBorderPainter(
                                                        color: const Color(0xffD8E0EC),
                                                      ),
                                                      child: SizedBox(
                                                        height: 150,
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: controller.businessLogo ==
                                                                  null
                                                              ? const Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .image_outlined,
                                                                        size: 40,
                                                                        color: Colors.grey),
                                                                    SizedBox(height: 8),
                                                                    Text(
                                                                      "Select business logo",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          8.0),
                                                                  child: Image.file(
                                                                    fit: BoxFit.cover,
                                                                    File(controller
                                                                        .businessLogo!),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  addH(8.h),
                                                  const FieldTitle(
                                                    "Owner photo",
                                                  ),
                                                  addH(8.h),
                                                  InkWell(
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(8)),
                                                    onTap: () => controller.selectFile(
                                                        ownerLogo: true),
                                                    child: CustomPaint(
                                                      painter: DottedBorderPainter(
                                                        color: const Color(0xffD8E0EC),
                                                      ),
                                                      child: SizedBox(
                                                        height: 150,
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: controller.ownerPhoto ==
                                                                  null
                                                              ? const Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .image_outlined,
                                                                        size: 40,
                                                                        color: Colors.grey),
                                                                    SizedBox(height: 8),
                                                                    Text(
                                                                      "Select your photo",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          8.0),
                                                                  child: Image.file(
                                                                    fit: BoxFit.cover,
                                                                    File(controller
                                                                        .ownerPhoto!),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Obx(() {
                                              if (controller.authStep.value ==
                                                      AuthStep.otpSent ||
                                                  controller.authStep.value ==
                                                      AuthStep.verifyingOtp ||
                                                  controller.authStep.value ==
                                                      AuthStep.otpVerifyingFailed) {
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
                                                      padding: EdgeInsets.only(
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
                                                                              .sendOTP(phoneCon
                                                                                  .text
                                                                                  .trim());
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
                                                                        MaterialStateProperty
                                                                            .all(0),
                                                                    backgroundColor:
                                                                        MaterialStateProperty
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
                                                                    style: TextStyle(
                                                                      color: Colors.red,
                                                                      fontFamily: 'Poppins',
                                                                      fontSize: 12,
                                                                    ),
                                                                    children: [
                                                                      TextSpan(
                                                                        text: '00:$_time',
                                                                        style: TextStyle(
                                                                          color: Colors.red,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          fontSize: 12,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
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
                                                return SizedBox.shrink();
                                              }
                                            }),
                                            addH(24),
                                            Obx(() {
                                              final step = controller.authStep.value;
                                              // final formValid = formKey.currentState?.validate() ?? false;

                                              if (step == AuthStep.sendingOtp ||
                                                  step == AuthStep.verifyingOtp ||
                                                  step == AuthStep.signingUp) {
                                                return CustomBtn(
                                                  btnColor: Colors.grey,
                                                  onPressedFn: () {},
                                                  btnTxt: 'Processing...',
                                                  txtSize: 18,
                                                );
                                              }

                                              if (step == AuthStep.otpSent) {
                                                return CustomBtn(
                                                  btnColor: AppColors.primary,
                                                  onPressedFn: () => controller.verifyOTP(
                                                      pinPutController.text,
                                                      phoneCon.text.trim()),
                                                  btnTxt: 'Verify OTP',
                                                  txtSize: 18,
                                                );
                                              }

                                              if (step == AuthStep.otpVerified) {
                                                return CustomBtn(
                                                  btnTxt: "Sign Up",
                                                  btnColor: AppColors.primary,
                                                  onPressedFn: () async {
                                                    bool check = await validate();
                                                    if (check) {
                                                      var req = await prepareData();
                                                      controller.signUp(req);
                                                    } else {
                                                      return;
                                                    }
                                                  },
                                                );
                                              }

                                              if (step == AuthStep.signUpSuccess) {
                                                Future.delayed(Duration(seconds: 1), () {
                                                  Get.offAllNamed(LoginScreen.routeName);
                                                });
                                                return CustomBtn(
                                                  btnTxt: "Registration Success!",
                                                  btnColor: Colors.blue,
                                                  onPressedFn: () {},
                                                );
                                              }

                                              if (step == AuthStep.otpSendingFailed ||
                                                  step == AuthStep.otpVerifyingFailed ||
                                                  step == AuthStep.signingUpFailed) {
                                                return CustomBtn(
                                                  btnTxt: "Try Again",
                                                  btnColor: AppColors.error,
                                                  onPressedFn: () async {
                                                    if (step == AuthStep.otpSendingFailed) {
                                                      bool check =
                                                          await validatePhoneNumber();
                                                      if (check) {
                                                        bool sent = await controller
                                                            .sendOTP(phoneCon.text.trim());
                                                        if (sent) {
                                                          startTimer();
                                                        }
                                                      }
                                                    } else if (step ==
                                                        AuthStep.otpVerifyingFailed) {
                                                      controller.verifyOTP(
                                                          pinPutController.text,
                                                          phoneCon.text.trim());
                                                    } else if (step ==
                                                        AuthStep.signingUpFailed) {
                                                      bool check = await validate();
                                                      if (check) {
                                                        var req = await prepareData();
                                                        controller.signUp(req);
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
                                                    bool sent = await controller
                                                        .sendOTP(phoneCon.text.trim());
                                                    if (sent) {
                                                      startTimer();
                                                    }
                                                  }
                                                },
                                              );
                                            }),
                                            addH(50)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?",style: TextStyle(fontSize: 14)),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text('Sign in',
                                    style: TextStyle(
                                        color: AppColors.accent,fontSize: 16,fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          addH(16),
                        ],
                      ),
                    ),
                  );
                }
              ),
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
        isMandatory != null
            ? RichFieldTitle(
                text: title,
                fontSize: context.textTheme.titleSmall?.fontSize,
              )
            : FieldTitle(
                title,
                fontSize: context.textTheme.titleSmall?.fontSize,
              ),
        addH(4),
        CustomGlassMorfTextField(
          textCon: con,
          hintText: 'Enter $title',
          txtSize: 16.sp,
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

class TabbarItem extends StatelessWidget {
  final VoidCallback onTapFn;
  final String title;
  final bool isSelected;

  const TabbarItem({
    Key? key,
    required this.onTapFn,
    required this.title,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTapFn,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: isSelected ? 4 : 1,
                color: AppColors.primary,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
