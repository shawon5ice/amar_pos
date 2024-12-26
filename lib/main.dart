import 'package:amar_pos/features/auth/data/model/hive/login_data_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'core/routes/router.dart';
import 'core/theme/app_theme.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'features/splash/splash_screen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.ios);
  // FirebaseService().initNotification();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  LoginDataBoxManager.init();

  // Open the box
  await LoginDataBoxManager().initBox();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.allRoutes,
      initialRoute: SplashScreen.routeName,
      // initialBinding: InitialBinding(),
      theme: AppTheme(context).getLightTheme(),
      // darkTheme: AppTheme(context).getDarkTheme(),
      builder: EasyLoading.init(builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      }),
      // home: DrawerSetup(),
    );
  }
}
