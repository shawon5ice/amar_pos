import 'package:amar_pos/features/auth/data/model/hive/login_data.dart';
import 'package:amar_pos/features/auth/data/model/hive/login_data_helper.dart';
import 'package:amar_pos/features/inventory/presentation/inventory_screen.dart';
import 'package:amar_pos/features/inventory/presentation/products/products_screen.dart';
import 'package:get/get.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
import 'package:amar_pos/features/config/presentation/configuration_screen.dart';
import 'package:flutter/material.dart';
import 'package:amar_pos/features/drawer/model/drawer_items.dart';
import 'package:amar_pos/features/drawer/model/menu_selection.dart';

class DrawerMenuController extends GetxController {
  RxDouble xOffset = 0.0.obs;
  RxDouble yOffset = 0.0.obs;
  RxDouble scaleFactor = 1.0.obs;
  RxBool isDrawerOpened = false.obs;
  RxString currentScreen = HomeScreen.routeName.obs;
  bool isDragging = false;

  Rx<MenuSelection?> selectedMenuItem = Rx<MenuSelection?>(null);

  LoginData? loginData = LoginDataBoxManager().loginData;

  @override
  void onInit() {
    super.onInit();
    selectMenuItem(MenuSelection(parent: DrawerItems.overview));
    update();
  }

  @override
  void onReady() {
    loginData = LoginDataBoxManager().loginData;
    super.onReady();
  }


  void openDrawer() {
    isDrawerOpened.value = true;
    xOffset.value = Get.width * 0.75;
    yOffset.value = Get.height * 0.1;
    scaleFactor.value = 0.8;
    update();
  }

  void closeDrawer() {
    isDrawerOpened.value = false;
    xOffset.value = 0;
    yOffset.value = 0;
    scaleFactor.value = 1.0;
  }

  void selectMenuItem(MenuSelection? menuItem) {
    selectedMenuItem.value = menuItem;
    closeDrawer();
  }

  // Returns the appropriate screen based on selectedMenuItem
  Widget getSelectedPage() {
    switch (selectedMenuItem.value?.parent) {
      case DrawerItems.overview:
        currentScreen.value = HomeScreen.routeName;
        return const HomeScreen(); // Default to HomeScreen
      case DrawerItems.inventory:
        if(selectedMenuItem.value?.child == "Product List"){
          return ProductsScreen();
        }else{
          return Container();
        }
        // Replace with the actual sales screen widget actual inventory screen widget
      case DrawerItems.sales:
        if(selectedMenuItem.value?.child == "Product List"){
          return ProductsScreen();
        }else{
          return Container();
        }
        // / Replace with the actual sales screen widget
      case DrawerItems.config:
        currentScreen.value = ConfigurationScreen.routeName;
        return ConfigurationScreen(); // Configuration screen widget
      default:
        return const HomeScreen(); // Fallback to HomeScreen
    }
  }
}
