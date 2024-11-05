import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/home/presentation/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key,required this.openDrawer});

  final VoidCallback openDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      // drawer: CustomDrawer(),
      appBar: AppBar(
        leading: DrawerMenuWidget(onClicked: openDrawer),
        title: Text("H O M E"),
        actions: [
          IconButton(onPressed: (){
            Get.changeThemeMode(Get.isDarkMode? ThemeMode.light : ThemeMode.dark);
          }, icon: Get.isDarkMode? Icon(Icons.sunny): Icon(Icons.nightlight))
        ],
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}


class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({Key? key, required this.onClicked}) : super(key: key);

  final VoidCallback onClicked;
  

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onClicked, icon: Icon(Icons.menu));
  }
}
