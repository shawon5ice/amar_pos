import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../permission_manager.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    initializePermissions();
    super.initState();
  }

  void initializePermissions() async {
    await PermissionManager.loadPermissions();
  }
  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      // drawer: CustomDrawer(),
      appBar: AppBar(
        leading: DrawerMenuWidget(onClicked: drawerMenuController.openDrawer),
        title: const Text("H O M E"),
        actions: [
          IconButton(onPressed: (){
            Get.changeThemeMode(Get.isDarkMode? ThemeMode.light : ThemeMode.dark);
          }, icon: Get.isDarkMode? Icon(Icons.sunny): Icon(Icons.nightlight))
        ],
      ),
      body: const Column(
        children: [

        ],
      ),
    );
  }
}


class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({super.key, required this.onClicked});

  final VoidCallback onClicked;
  

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onClicked, icon: const Icon(Icons.menu));
  }
}
