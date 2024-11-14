import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/data/preference.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_field.dart';
import '../../../../../core/widgets/methods/helper_methods.dart';
import '../../controller/auth_controller.dart';
import '../login_screen.dart';
import '../widgets/auth_header.dart';

class PasswordEntryPage extends StatelessWidget {
  static String routeName = '/password-entry';
  PasswordEntryPage({super.key,});

  final TextEditingController _passCon = TextEditingController();
  final TextEditingController _passCon2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: InkWell(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: GetBuilder<AuthController>(
            id: 'forgot_password_view',
            builder: (controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(title: "Forgot Password"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // email title
                      buildFieldTitle('Password'),
                      addH(10.h),
                      // password field
                      CustomField(
                        textCon: _passCon,
                        hintText: 'Enter password',
                        isPassField: true,
                        txtSize: 14.px,
                      ),
                      addH(20.h),
                      buildFieldTitle('Retype Password'),
                      addH(10.h),
                      CustomField(
                        textCon: _passCon2,
                        hintText: 'Retype password',
                        isPassField: true,
                        txtSize: 14.sp,
                      ),
                      addH(20.h),
                      CustomBtn(
                        btnSize: Size(double.infinity, 55.h),
                        onPressedFn: ()async {
                          if(_passCon.text.isEmpty || _passCon2.text.isEmpty){
                            Methods.showSnackbar(msg: "Please enter valid password!");
                            return;
                          }else if(_passCon.text != _passCon2.text){
                            Methods.showSnackbar(msg: "Password doesn't match!");
                            return;
                          }
                          // await controller.sendPassword(password: _passCon.text.trim(),c_password: _passCon2.text).then((value) {
                          //   if(value){
                          //     Preference.logout();
                          //     Get.offAllNamed(LoginScreen.routeName);
                          //   }
                          // });
                        },
                        btnTxt: 'Submit',
                        txtSize: 16.sp,
                      ),
                      addH(180.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text buildFieldTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        color:
        //  context.isDarkMode ? ConstantColors.kC0C0C4 :
        const Color(0xFF1D3557),
      ),
    );
  }
}
