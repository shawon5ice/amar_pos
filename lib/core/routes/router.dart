import 'package:amar_pos/core/routes/bindings.dart';
import 'package:amar_pos/features/category/presentation/configuration_screen.dart';
import 'package:amar_pos/features/drawer/drawer.dart';
import 'package:amar_pos/features/drawer/main_page.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
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

    GetPage(
      name: HomeScreen.routeName,
      page: () => const HomeScreen(),
      // binding: InitialBinding(),
    ),

    GetPage(
      name: ConfigurationScreen.routeName,
      page: () => ConfigurationScreen(),
      // binding: InitialBinding(),
    ),

    GetPage(
      name: MainPage.routeName,
      page: () => MainPage(),
      binding: MainBinding(),
    ),

  ];
}
