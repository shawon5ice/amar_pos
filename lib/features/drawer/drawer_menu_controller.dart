import 'package:amar_pos/features/category/presentation/configuration_screen.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:amar_pos/features/drawer/model/drawer_items.dart';
import 'package:amar_pos/features/drawer/model/menu_selection.dart';

class DrawerMenuController extends GetxController {
  // Observable state variables (Rx)
  RxDouble xOffset = 0.0.obs;
  RxDouble yOffset = 0.0.obs;
  RxDouble scaleFactor = 1.0.obs;
  RxBool isDrawerOpened = false.obs;

  Rx<MenuSelection?> selectedMenuItem = Rx<MenuSelection?>(MenuSelection(parent: DrawerItems.overview));

  bool isDragging = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Your logic to select the default menu item and navigate
      selectedMenuItem.value = MenuSelection(parent: DrawerItems.overview);
      navigateToPage(selectedMenuItem.value); // Trigger the navigation here
    });
  }

  // Open Drawer Logic
  void openDrawer() {
    isDrawerOpened.value = true;
    xOffset.value = Get.width * 0.75;
    yOffset.value = Get.height * 0.1;
    scaleFactor.value = 0.8;
  }

  // Close Drawer Logic
  void closeDrawer() {
    isDrawerOpened.value = false;
    xOffset.value = 0;
    yOffset.value = 0;
    scaleFactor.value = 1.0;
  }

  // Toggle Drawer
  void toggleDrawer() {
    if (isDrawerOpened.value) {
      closeDrawer();
    } else {
      openDrawer();
    }
  }

  void selectMenuItem(MenuSelection? menuItem) {
    bool isSameItemSelected = menuItem?.parent == selectedMenuItem.value?.parent && menuItem?.child == selectedMenuItem.value?.child;

    if (isSameItemSelected) {
      closeDrawer();
    } else {
      bool isParentWithChildren = menuItem?.parent == DrawerItems.sales && menuItem?.child == null;

      if (!isParentWithChildren) {
        selectedMenuItem.value = menuItem;
      }
      if (!isParentWithChildren || menuItem?.child != null) {
        closeDrawer();
      }
    }

    // Handle navigation based on menu item selection
    navigateToPage(menuItem);
  }

  void navigateToPage(MenuSelection? menuItem) {
    // Perform navigation based on the menu item selected
    switch (menuItem?.parent) {
      case DrawerItems.overview:
        Get.toNamed(HomeScreen.routeName); // Navigate to home screen
        break;
      case DrawerItems.inventory:
        Get.toNamed('/inventory'); // Navigate to inventory screen
        break;
      case DrawerItems.sales:
        Get.toNamed('/sales'); // Example route for sales
        break;
      case DrawerItems.config:
        Get.toNamed(ConfigurationScreen.routeName); // Navigate to configuration screen
        break;
      default:
        Get.toNamed('/home'); // Fallback to a default route (e.g., HomeScreen)
        break;
    }
  }

  Widget getDrawerPage() {
    if (selectedMenuItem.value?.parent == DrawerItems.sales && selectedMenuItem.value?.child == null) {
      return Container(); // Do nothing if parent with children but no child selected
    }

    // You can also navigate programmatically based on the selected menu here
    return Container();
  }
}
