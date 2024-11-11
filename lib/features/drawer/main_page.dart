import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/category/presentation/configuration_screen.dart';
import 'package:amar_pos/features/drawer/model/drawer_items.dart';
import 'package:amar_pos/features/drawer/model/menu_selection.dart';
import 'package:amar_pos/features/drawer/widget/drawer_widget.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';

class MainPage extends StatelessWidget {
  static const String routeName = "/main";
  final DrawerMenuController menuController = Get.put(DrawerMenuController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (menuController.isDrawerOpened.value) {
          menuController.closeDrawer();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.darkGreen,
        body: SafeArea(
          child: Stack(
            children: [
              // Use GetBuilder to rebuild the drawer state
              GetBuilder<DrawerMenuController>(
                builder: (_) {
                  return buildDrawer();
                },
              ),
              buildPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return DrawerWidget(
      onSelectedItem: (value) {
        // Handle item selection
        // Call the menuController to update the selected item and potentially navigate
        menuController.toggleDrawer();
      },
    );
  }

  Widget buildPage() {
    return GestureDetector(
      onTap: () {
        menuController.closeDrawer(); // Close the drawer when tapping outside
      },
      child: GetBuilder<DrawerMenuController>(
        builder: (_) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            transform: Matrix4.translationValues(menuController.xOffset.value, menuController.yOffset.value, 0)
              ..scale(menuController.scaleFactor.value),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(menuController.isDrawerOpened.value ? 20 : 0)),
              child: AbsorbPointer(
                absorbing: menuController.isDrawerOpened.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: menuController.isDrawerOpened.value
                        ? Colors.white12
                        : AppColors.scaffoldBackground,
                  ),
                  child: getDrawerPage(), // Your existing page logic
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getDrawerPage() {
    // Use the selectedMenuItem or handle routing to different pages
    return HomeScreen(arguments: () {
      // Open the drawer if needed
      menuController.openDrawer();
    });
  }
}
