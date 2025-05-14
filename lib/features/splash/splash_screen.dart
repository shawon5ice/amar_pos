import 'dart:async';

import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/data/preference.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/auth/data/model/hive/login_data_helper.dart';
import 'package:amar_pos/features/auth/presentation/ui/login_screen.dart';
import 'package:amar_pos/features/drawer/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../drawer/drawer.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late Box<HiveUserModel> userItems;
  // final HomeController homeController = Get.put(HomeController());

  // Will get the bool value from shared_preferences
  // will return 0 if null
  // Future<bool> _getBoolFromSharedPref() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.getBool(ConstantStrings.openFlag) ?? false;
  // }

  // Set the value in shared_preferences to true
  // Future<void> _setValue() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(ConstantStrings.openFlag, true);
  // }

  static const platform = MethodChannel("com.motionsoft.amar_pos/app_info");

  String _version = 'Unknown';
  String _buildNumber = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getAppInfo();
    handleInitialMessage();
    // appUpdate();
    navigate();
  }

  Future<void> _getAppInfo() async {
    try {
      final version = await platform.invokeMethod('getAppVersion');
      final buildNumber = await platform.invokeMethod('getBuildNumber');
      setState(() {
        _version = version;
        _buildNumber = buildNumber;
      });
    } on PlatformException catch (e) {
      setState(() {
        _version = 'Failed to get version: ${e.message}';
        _buildNumber = 'Failed to get build number: ${e.message}';
      });
    }
  }

  void navigate() {
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        if (LoginDataBoxManager().loginData != null) {
          Get.offAndToNamed(MainPage.routeName);
        } else {
          Get.offAndToNamed(LoginScreen.routeName);
        }
      },
    );

    // userItems = Boxes.getUserItems();
    // if (userItems.isNotEmpty) {
    //   // generate a new uuid each time
    //   var uuid = const Uuid();
    //   userItems.getAt(0)!.uuID = uuid.v4();
    //   userItems.getAt(0)!.save();
    // }
    // _checkStartUp();
  }

  // void appUpdate() async {
  //   try {
  //     InAppUpdate.checkForUpdate().then((updateInfo) {
  //       if (updateInfo.updateAvailability ==
  //           UpdateAvailability.updateAvailable) {
  //         if (updateInfo.immediateUpdateAllowed) {
  //           InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
  //             if (appUpdateResult == AppUpdateResult.success) {
  //               // AllMethods.showSnackBar(
  //               //     message: 'App Updated Successfully!',
  //               //     title: 'Success',
  //               //     icon: Icons.info);
  //             }
  //           });
  //         }
  //       } else if (updateInfo.flexibleUpdateAllowed) {
  //         InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
  //           if (appUpdateResult == AppUpdateResult.success) {
  //             InAppUpdate.completeFlexibleUpdate();
  //           }
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     Log.logger.e(e);
  //   }
  // }

  // Future<void> _checkStartUp() async {
  //   bool haveOpened = await _getBoolFromSharedPref();
  //
  //   HomeController _homeController = Get.find();
  //
  //   _homeController.getSiteSettings().then((value){
  //     if (haveOpened) {
  //       Timer(
  //         const Duration(milliseconds: 500),
  //             () => Get.offNamed(DrawerSetup.routeName),
  //       );
  //     } else {
  //       // _setValue();
  //       Timer(
  //         const Duration(milliseconds: 500),
  //             () => Get.offNamed(IntroScreen.routeName),
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   context.theme.appBarTheme.systemOverlayStyle,
    // );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.amarPosLogo,
                    width: 200,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                      height: 100,
                      child: RandomLottieLoader.lottieLoader())
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.motionSoftLogo,
                      width: 220,
                      height: 48,
                      fit: BoxFit.fitHeight,
                    ),
                    addH(24),
                    Text(
                      'V$_version($_buildNumber)',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
