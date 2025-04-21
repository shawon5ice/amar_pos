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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // backgroundColor: AppColors.accent,
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: GetBuilder<AuthController>(
                id: 'remember_me',
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => AuthHeader(title: "Sign In", error: controller.message.value,),),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // email title
                            const FieldTitle("Email or phone number",),
                            addH(8.h),
                            // email field
                            CustomGlassMorfTextField(
                              textCon: controller.emailController,
                              hintText: 'Enter email or phone number',
                              txtSize: 14.sp,
                              inputType: TextInputType.emailAddress,
                              focusNode: controller.emailFocus,
                              errorText: "⚠️ Please insert your email/phone number!",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  controller.emailFocus.requestFocus();
                                  return '⚠️ Please insert your email/phone number!';
                                }
                                return null;
                              },
                            ),
                            addH(24.h),
                            // password title
                            buildFieldTitle('Password'),
                            addH(8.h),
                            // password field
                            CustomGlassMorfTextField(
                              textCon: controller.passwordController,
                              hintText: 'Enter password',
                              isPassField: true,
                              txtSize: 14.sp,
                              focusNode: controller.passwordFocus,
                              validator: (value) {
                                if ((value == null || value.isEmpty) &&
                                    controller.emailController.text.isNotEmpty) {
                                  controller.passwordFocus.requestFocus();
                                  return '⚠️ Please insert your password';
                                }
                                return null;
                              },
                            ),
                            addH(10.h),
                            // remember me & forgot password btn
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // remember me
                                GestureDetector(
                                  onTap: (){
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    controller.handleRememberMe();
                                  },
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: controller.rememberMeFlag,
                                        onChanged: (value) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          controller.handleRememberMe(remember: value);
                                        },
                                        activeColor: AppColors.primary,
                                        splashRadius: 0,
                                        materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Remember Me',
                                        style: context.textTheme.titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                CustomTxtBtn(
                                  onTapFn: () => AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.question,
                                    headerAnimationLoop: false,
                                    title: "Forgot Password",
                                    desc: "how you want to reset your password?",
                                    btnCancelColor: Colors.green,
                                    btnOkColor: Colors.green,
                                    btnOkText: "via Phone",
                                    btnOkOnPress: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      Get.toNamed(ForgotPasswordScreen.routeName);
                                    },
                                    btnCancelText: null,
                                    btnCancelOnPress: null,
                                    // btnCancelOnPress: () => Get.toNamed(
                                    //   ForgetPasswordScreen.routeName,
                                    //   arguments: true, // true means email
                                    // ),
                                  ).show(),
                                  text: 'Forgot Password?',
                                  txtSize: 12,
                                  txtClr: Colors.red,
                                ),
                              ],
                            ),
                            addH(24),
                            CustomBtn(
                              btnColor: AppColors.accent,
                              onPressedFn: () {
                                if(!formKey.currentState!.validate()){
                                  return;
                                }else{
                                  controller.signIn();
                                }
                              },
                              btnTxt: 'Sign In',
                              txtSize: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    addH(50.h),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(onPressed: (){
                          Get.toNamed(RegistrationScreen.routeName,);
                        }, child: Text('Sign up',style: TextStyle(color: AppColors.accent),))
                      ],
                    )
                  ],
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
}