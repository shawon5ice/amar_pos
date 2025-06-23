import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/widgets/custom_btn.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/auth/presentation/ui/registration_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/responsive/pixel_perfect.dart';
import '../../../../core/widgets/custom_glass_morf_field.dart';
import '../../../../core/widgets/custom_txt_btn.dart';
import '../controller/auth_controller.dart';
import 'forget_password/forgot_password.dart';
import 'widgets/auth_header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends GetView<AuthController> {
  static String routeName = '/login_screen';

  LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();

//AnnotatedRegion
  // value: const SystemUiOverlayStyle(
  // statusBarColor: Colors.transparent,
  // statusBarIconBrightness: Brightness.dark,
  // ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom, // ensures view adjusts for keyboard
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top logo
                    Padding(
                      padding: EdgeInsets.only(top: constraints.maxHeight/6),
                      child: Center(
                        child: Image.asset(
                          AppAssets.amarPosLogo,
                          height: 110,
                          width: 200,
                        ),
                      ),
                    ),

                    // Form (non-scrollable but expands as needed)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: GetBuilder<AuthController>(
                        id: 'remember_me',
                        builder: (controller) => Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addH(20),
                              Center(
                                child: Obx(() => Text(
                                      controller.message.value ?? '',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                              color: AppColors.error),
                                    )),
                              ),
                              addH(24),
                              const FieldTitle("Email or phone number"),
                              addH(8),
                              CustomGlassMorfTextField(
                                textCon: controller.emailController,
                                hintText: 'Enter email or phone number',
                                txtSize: 18.sp,
                                inputType: TextInputType.emailAddress,
                                focusNode: controller.emailFocus,
                                errorText:
                                    "⚠️ Please insert your email/phone number!",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    controller.emailFocus.requestFocus();
                                    return '⚠️ Please insert your email/phone number!';
                                  }
                                  return null;
                                },
                              ),
                              addH(24),
                              buildFieldTitle('Password'),
                              addH(8),
                              CustomGlassMorfTextField(
                                textCon: controller.passwordController,
                                hintText: 'Enter password',
                                isPassField: true,
                                txtSize: 18.sp,
                                focusNode: controller.passwordFocus,
                                validator: (value) {
                                  if ((value == null || value.isEmpty) &&
                                      controller.emailController.text
                                          .isNotEmpty) {
                                    controller.passwordFocus
                                        .requestFocus();
                                    return '⚠️ Please insert your password';
                                  }
                                  return null;
                                },
                              ),
                              addH(10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: controller.handleRememberMe,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value:
                                              controller.rememberMeFlag,
                                          onChanged: (value) =>
                                              controller.handleRememberMe(
                                                  remember: value),
                                          activeColor: AppColors.primary,
                                          splashRadius: 0,
                                        ),
                                        Text('Remember Me',
                                            style: context
                                                .textTheme.titleSmall),
                                      ],
                                    ),
                                  ),
                                  CustomTxtBtn(
                                    onTapFn: () => AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.question,
                                      title: "Forgot Password",
                                      desc:
                                          "how you want to reset your password?",
                                      btnOkText: "via Phone",
                                      btnOkColor: Colors.green,
                                      btnOkOnPress: () => Get.toNamed(
                                          ForgotPasswordScreen.routeName),
                                    ).show(),
                                    text: 'Forgot Password?',
                                    txtClr: Colors.red,
                                  ),
                                ],
                              ),
                              addH(12),
                              CustomBtn(
                                btnColor: AppColors.accent,
                                onPressedFn: () {
                                  if (!formKey.currentState!.validate())
                                    return;
                                  controller.signIn();
                                },
                                btnTxt: 'Sign In',
                                txtSize: 18,
                              ),
                              addH(40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?",style: TextStyle(fontSize: 14)),
                                  TextButton(
                                    onPressed: () => Get.toNamed(
                                        RegistrationScreen.routeName),
                                    child: Text('Sign up',
                                        style: TextStyle(
                                            color: AppColors.accent,fontSize: 16,fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bottom logo
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Center(
                        child: Image.asset(
                          AppAssets.motionSoftLogo,
                          height: 48,
                          width: 120,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
}
