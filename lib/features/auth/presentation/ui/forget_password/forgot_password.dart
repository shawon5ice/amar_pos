import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/custom_glass_morf_field.dart';
import '../../../../../core/widgets/field_title.dart';
import '../../controller/auth_controller.dart';
import '../widgets/auth_header.dart';
import 'password_entry_page.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = '/forgot_password';

  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthController _authCon = Get.find<AuthController>();

  @override
  void initState() {
    // _authCon.verificationDone.listen((value) {
    //   if(value){
    //     _authCon.otpSend(false);
    //     Get.offAndToNamed(PasswordEntryPage.routeName);
    //   }
    // });
    super.initState();
  }
  bool showOTPVerify = false;

  PinTheme _pinTheme = PinTheme(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: Colors.white,
      border: Border.all(
        color: Colors.black,
      ),
    ),
  );

  PinTheme _pinThemeFocus = PinTheme(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: Colors.white,
      border: Border.all(
        color: Colors.blueAccent,
      ),
    ),
  );

  final TextEditingController _pinCon = TextEditingController();

  FocusNode _pinFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        // if(_authCon.otpSend.value){
        //   _authCon.otpSend(false);
        //   _pinCon.clear();
        //   _authCon.update(['forgot_password_view']);
        //   return false;
        // }
        return true;
      },
      child: Scaffold(
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
                  AuthHeader(title: "Forgot Password"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // email title
                        buildFieldTitle("Phone number"),
                        addH(10),
                        CustomGlassMorfTextField(
                          enabledFlag: !_authCon.otpSend.value,
                          textCon: _authCon.phoneCon,
                          hintText: 'Enter your phone number',
                          inputType: TextInputType.phone,
                          txtSize: 18.sp,
                        ),
                        addH(20.h),
                        Visibility(
                          visible: _authCon.otpSend.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FieldTitle('Enter OTP'),
                              addH(10.h),
                              Center(
                                child: Pinput(
                                  controller: _pinCon,
                                  length: 6,
                                  focusNode: _pinFocus,
                                  defaultPinTheme: _pinTheme,
                                  focusedPinTheme: _pinThemeFocus,
                                  submittedPinTheme: _pinTheme,
                                  followingPinTheme: _pinTheme,
                                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                  showCursor: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(_authCon.otpSend.value) addH(20.h),
                        CustomBtn(
                          btnSize: Size(double.infinity, 55.h),
                          onPressedFn: ()async {
                            // await _authCon.sendOTP(isForVerification: _authCon.otpSend.value,otp: _pinCon.text);
                          },
                          btnTxt: showOTPVerify?'Submit':'Next',
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
