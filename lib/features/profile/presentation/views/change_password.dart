import 'dart:async';

import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_btn.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/profile/presentation/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_glass_morf_field.dart';
import '../../../../core/widgets/methods/helper_methods.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController cNewPasswordController;
  final FocusNode pinPutFocusNode = FocusNode();
  final TextEditingController pinPutController = TextEditingController();
  final ProfileController controller = Get.find();

  @override
  void initState() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    cNewPasswordController = TextEditingController();
    super.initState();
  }

  Timer? _timer;
  int _time = 59;


  Future<bool> validate() async {
    if (oldPasswordController.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter your old password");
      return false;
    } else if (newPasswordController.text.isEmpty) {
      Methods.showSnackbar(msg: "Please enter a new password");
      return false;
    } else if (cNewPasswordController.text.isEmpty) {
      Methods.showSnackbar(msg: "Please retype your new password");
      return false;
    } else if (newPasswordController.text != cNewPasswordController.text) {
      Methods.showSnackbar(msg: "Please match both password");
      return false;
    }

    return true;
  }

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

  @override
  void dispose() {
    newPasswordController.clear();
    oldPasswordController.clear();
    cNewPasswordController.clear();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addH(20),
            const RichFieldTitle(text: "Old Password"),
            addH(4),
            CustomGlassMorfTextField(

              textCon: oldPasswordController,
              hintText: 'Enter current password',
              isPassField: true,
              txtSize: 14,
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    oldPasswordController.text.isNotEmpty) {
                  return '⚠️ Please insert your current password';
                }
                return null;
              },
            ),
            addH(12),
            const RichFieldTitle(text: "New Password"),
            addH(4),
            CustomGlassMorfTextField(
              textCon: newPasswordController,
              hintText: 'Enter new password',
              isPassField: true,
              txtSize: 14,
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    newPasswordController.text.isNotEmpty) {
                  return '⚠️ Please insert your new password';
                }
                return null;
              },
            ),
            addH(12),
            const RichFieldTitle(text: "Re-ype New Password"),
            addH(4),
            CustomGlassMorfTextField(
              textCon: cNewPasswordController,
              hintText: 'Enter new password',
              isPassField: true,
              txtSize: 14,
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    cNewPasswordController.text.isNotEmpty) {
                  return '⚠️ Please insert your new password';
                }
                return null;
              },
            ),
            addH(24),
            Obx(() {
              if (controller.changePasswordStep.value ==
                  ChangePasswordStep.otpSent ||
                  controller.changePasswordStep.value ==
                      ChangePasswordStep.verifyingOtp ||
                  controller.changePasswordStep.value ==
                      ChangePasswordStep.otpVerifyingFailed) {
                return Column(
                  children: [
                    addH(12),
                    Pinput(
                      length: 6,
                      focusNode: pinPutFocusNode,
                      controller: pinPutController,
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
                              bool sent =
                              await controller
                                  .sendOTP(
                                oldPasswordController.text,
                                newPasswordController.text
                              );
                              if (sent) {
                                startTimer();
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
                                AppColors.accent,
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
            addH(12),
            Obx(() {
              final step = controller.changePasswordStep.value;
              // final formValid = formKey.currentState?.validate() ?? false;

              if (
              step == ChangePasswordStep.sendingOtp ||
              step == ChangePasswordStep.changingPassword ||
                  step == ChangePasswordStep.verifyingOtp) {
                return CustomBtn(
                  btnColor: Colors.grey,
                  onPressedFn: () {},
                  btnTxt: 'Processing...',
                  txtSize: 18,
                );
              }

              if (step == ChangePasswordStep.otpSent) {
                return CustomBtn(
                  btnColor: AppColors.primary,
                  onPressedFn: () => controller
                      .verifyOTP(pinPutController.text,oldPasswordController.text, newPasswordController.text),
                  btnTxt: 'Verify OTP & Change Password',
                  txtSize: 18,
                );
              }

              if (step == ChangePasswordStep.passwordChanged) {
                // Future.delayed(Duration(seconds: 1), () {
                //   Get.offAllNamed(LoginScreen.routeName);
                // });
                return CustomBtn(
                  btnTxt: "Password Changed Successfully",
                  btnColor: AppColors.primary.withOpacity(.3),
                  onPressedFn: () {},
                );
              }

              if (step == ChangePasswordStep.otpSendingFailed ||
                  step == ChangePasswordStep.otpVerifyingFailed) {
                return CustomBtn(
                  btnTxt: "Try Again",
                  btnColor: AppColors.error,
                  onPressedFn: () async {
                    if (step == ChangePasswordStep.otpSendingFailed) {
                      bool sent =
                      await controller.sendOTP(
                        oldPasswordController.text,
                        newPasswordController.text,
                      );
                      if (sent) {
                        startTimer();
                      }
                    } else if (step == ChangePasswordStep.otpVerifyingFailed) {
                      controller.verifyOTP(pinPutController.text,oldPasswordController.text, newPasswordController.text);
                    }else if(step == ChangePasswordStep.changingPasswordFailed){
                      controller.changePassword(oldPasswordController.text, newPasswordController.text);
                    }
                  },
                );
              }

              return CustomBtn(
                btnTxt: "Get OTP",
                btnColor: AppColors.accent,
                onPressedFn: () async {
                  bool check = await validate();
                  if (check) {
                    bool sent = await controller.sendOTP(
                      oldPasswordController.text,
                      newPasswordController.text
                    );
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
    );
  }
}
