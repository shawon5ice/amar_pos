import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/features/accounting/presentation/accounting_screen.dart';
import 'package:amar_pos/features/auth/data/model/hive/login_data.dart';
import 'package:amar_pos/features/auth/data/model/hive/login_data_helper.dart';
import 'package:amar_pos/features/exchange/exchange_screen.dart';
import 'package:amar_pos/features/home/presentation/home_screen_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/products_screen.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/stock_report.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_screen.dart';
import 'package:amar_pos/features/purchase_return/presentation/purchase_return_screen.dart';
import 'package:amar_pos/features/return/presentation/return_screen.dart';
import 'package:get/get.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
import 'package:amar_pos/features/config/presentation/configuration_screen.dart';
import 'package:flutter/material.dart';
import 'package:amar_pos/features/drawer/model/drawer_items.dart';
import 'package:amar_pos/features/drawer/model/menu_selection.dart';

import '../../permission_manager.dart';
import '../sales/presentation/sales_screen.dart';

class DrawerMenuController extends GetxController {
  RxDouble xOffset = 0.0.obs;
  RxDouble yOffset = 0.0.obs;
  RxDouble scaleFactor = 1.0.obs;
  RxBool isDrawerOpened = false.obs;
  RxString currentScreen = HomeScreen.routeName.obs;
  bool isDragging = false;

  Rx<MenuSelection?> selectedMenuItem = Rx<MenuSelection?>(null);

  LoginData? loginData = LoginDataBoxManager().loginData;
  //Menus to active
  List<String> purchaseModule = [];
  bool salesModule = false;

  @override
  void onInit() {
    super.onInit();
    selectMenuItem(MenuSelection(parent: DrawerItems.overview));
    update();
  }

  Future<void> loadModules() async {
    purchaseModule.clear();
    print("--->");
    if(PermissionManager.hasParentPermission('PurchaseOrder')){
      purchaseModule.add("Purchase");
    }
    if(PermissionManager.hasParentPermission('PurchaseReturn')){
      purchaseModule.add("Purchase Return");
    }
    if(PermissionManager.hasParentPermission('Order')){
      salesModule = true;
    }
    logger.d(salesModule);
    update(['drawer_menu']);
  }

  void openDrawer() {
    isDrawerOpened.value = true;
    xOffset.value = Get.width * 0.65;
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

  // String getSelectedPage() {
  //   // Return the route name or page identifier
  //   switch (selectedMenuItem.value?.parent) {
  //     case DrawerItems.overview:
  //       return '/overview';
  //     case DrawerItems.config:
  //       return ConfigurationScreen.routeName;
  //     case DrawerItems.reports:
  //       return '/reports';
  //     default:
  //       return '/overview'; // Default route
  //   }
  // }

  // Returns the appropriate screen based on selectedMenuItem
  Widget getSelectedPage() {
    switch (selectedMenuItem.value?.parent) {
      case DrawerItems.overview:
        currentScreen.value = HomeScreen.routeName;
        return const HomeScreen(); // Default to HomeScreen
      case DrawerItems.inventory:
        if(selectedMenuItem.value?.child == "Product List"){
          return const ProductsScreen();
        }else if(selectedMenuItem.value?.child == "Stock Report"){
          return const StockReportScreen();
        }else{
          return Container();
        }
      case DrawerItems.sales:
        logger.i("SALES");
        currentScreen.value = SalesScreen.routeName;
        return const SalesScreen();
      case DrawerItems.returnAndExchange:
        if(selectedMenuItem.value?.child == "Return"){
          return const ReturnScreen();
        }else if(selectedMenuItem.value?.child == "Exchange"){
          return const ExchangeScreen();
        }else{
          return Container();
        }

      case DrawerItems.purchase:
        if(selectedMenuItem.value?.child == "Purchase"){
          return const PurchaseScreen();
        }else if(selectedMenuItem.value?.child == "Purchase Return"){
          return const PurchaseReturnScreen();
        }else{
          return Container();
        }
      case DrawerItems.accounting:
        // currentScreen.value = ConfigurationScreen.routeName;
        return AccountingScreen();
      case DrawerItems.config:
        currentScreen.value = ConfigurationScreen.routeName;
        return ConfigurationScreen(); // Configuration screen widget
      default:
        return const HomeScreen(); // Fallback to HomeScreen
    }
  }
}
