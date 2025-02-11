import 'package:amar_pos/core/network/base_client.dart';
import 'package:amar_pos/features/auth/data/model/hive/login_data_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'core/routes/router.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // debugPaintSizeEnabled = true;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.ios);
  // FirebaseService().initNotification();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  LoginDataBoxManager.init();

  // Open the box
  await LoginDataBoxManager().initBox();

  runApp(
    const MyApp(),
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
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
              devicePixelRatio: (MediaQuery.of(context).devicePixelRatio).clamp(1.0, 2.0),
            ),
            child: child!,
          ),
        );
      }),
      // home: DrawerSetup(),
    );
  }
}
