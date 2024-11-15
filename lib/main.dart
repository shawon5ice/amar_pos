import 'package:amar_pos/features/auth/data/model/hive/login_data_helper.dart';
import 'package:amar_pos/features/drawer/drawer.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'core/routes/router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/model/hive/login_data.dart';
import 'features/splash/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  LoginDataBoxManager.init();

  // Open the box
  await LoginDataBoxManager().initBox();


  runApp(const MyApp());
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
      builder: EasyLoading.init(),
      // home: DrawerSetup(),
    );
  }
}
