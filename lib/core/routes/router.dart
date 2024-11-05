import 'package:amar_pos/features/drawer/drawer.dart';
import 'package:amar_pos/features/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage<dynamic>> allRoutes = [
    // GetPage(
    //   name: DrawerSetup.routeName,
    //   page: () => const DrawerSetup(),
    //   // binding: InitialBinding(),
    // ),

    GetPage(
      name: SplashScreen.routeName,
      page: () => const SplashScreen(),
      // binding: InitialBinding(),
    ),

  ];
}
