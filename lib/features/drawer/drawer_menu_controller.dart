import 'dart:collection';

import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/features/accounting/presentation/accounting_screen.dart';
import 'package:amar_pos/features/auth/data/model/hive/login_data.dart';
import 'package:amar_pos/features/auth/data/model/hive/login_data_helper.dart';
import 'package:amar_pos/features/exchange/exchange_screen.dart';
import 'package:amar_pos/features/home/presentation/home_screen_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/products_screen.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/stock_report.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/stock_tansfer.dart';
import 'package:amar_pos/features/profile/presentation/profile_screen.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_screen.dart';
import 'package:amar_pos/features/purchase_return/presentation/purchase_return_screen.dart';
import 'package:amar_pos/features/return/presentation/return_screen.dart';
import 'package:amar_pos/features/subscription/presentation/subscription_screen.dart';
import 'package:get/get.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
import 'package:amar_pos/features/config/presentation/configuration_screen.dart';
import 'package:flutter/material.dart';
import 'package:amar_pos/features/drawer/model/drawer_items.dart';
import 'package:amar_pos/features/drawer/model/menu_selection.dart';

import '../../permission_manager.dart';
import '../sales/presentation/sales_screen.dart';
import 'model/drawer_item.dart';

class DrawerMenuController extends GetxController {
  RxDouble xOffset = 0.0.obs;
  RxDouble yOffset = 0.0.obs;
  RxDouble scaleFactor = 1.0.obs;
  RxBool isDrawerOpened = false.obs;
  RxString currentScreen = HomeScreen.routeName.obs;
  bool isDragging = false;
  final LoginDataBoxManager manager = LoginDataBoxManager();

  Rx<MenuSelection?> selectedMenuItem = Rx<MenuSelection?>(null);

  LoginData? loginData = LoginDataBoxManager().loginData;
  //Menus to active
  Set<String> purchaseModule = Set();
  Set<String> returnAndExchangeModule = Set();
  Set<String> inventoryModule = Set();
  bool salesModule = false;

  @override
  void onInit() {
    super.onInit();
    update();
  }

  Future<void> loadModules() async {
    purchaseModule.clear();
    inventoryModule.clear();
    returnAndExchangeModule.clear();
    print("--->");
    loadSaleModule();
    loadPurchaseModule();
    loadReturnAndExchangeModule();
    loadInventoryModule();
    update(['drawer_menu']);
  }


  void loadSaleModule(){
    if(PermissionManager.hasParentPermission('Order')){
      salesModule = true;
    }else{
      salesModule = false;
    }
  }

  void loadInventoryModule(){

    if(PermissionManager.hasParentPermission('Inventory')){
      inventoryModule.add("Product List");
    }else{
      inventoryModule.remove("Product List");
    }
    if(PermissionManager.hasPermission('Inventory.productStockReport')){
      inventoryModule.add("Stock Report");
    }else{
      inventoryModule.remove("Stock Report");
    }if(PermissionManager.hasParentPermission('StockTransferOrder')){
      inventoryModule.add("Stock Transfer");
    }else{
      inventoryModule.remove("Stock Transfer");
    }
  }

  void loadPurchaseModule(){
    if(PermissionManager.hasParentPermission('PurchaseOrder')){
      purchaseModule.add("Purchase");
    }else{
      purchaseModule.remove("Purchase");
    }
    if(PermissionManager.hasParentPermission('PurchaseReturn')){
      purchaseModule.add("Purchase Return");
    }else{
      purchaseModule.remove("Purchase Return");
    }
  }

  void loadReturnAndExchangeModule(){
    if(PermissionManager.hasParentPermission('OrderReturn')){
      returnAndExchangeModule.add("Return");
    }else{
      returnAndExchangeModule.remove("Return");
    }
    if(PermissionManager.hasParentPermission('OrderExchange')){
      returnAndExchangeModule.add("Exchange");
    }else{
      returnAndExchangeModule.remove("Exchange");
    }
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

  void selectMenuItem(MenuSelection menuItem) {
    selectedMenuItem.value = menuItem;
    selectParent(menuItem.parent);
    if(menuItem.child != null){
      selectChild(menuItem.parent, menuItem.child!);
    }

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
      case DrawerItems.profile:
        return const ProfileScreen();
      case DrawerItems.overview:
        currentScreen.value = HomeScreen.routeName;
        return const HomeScreen();
      case DrawerItems.subscription:
        currentScreen.value = SubscriptionScreen.routeName;
        return const SubscriptionScreen();
      case DrawerItems.inventory:
        if(selectedMenuItem.value?.child == "Product List"){
          return const ProductsScreen();
        }else if(selectedMenuItem.value?.child == "Stock Report"){
          return const StockReportScreen();
        }else if(selectedMenuItem.value?.child == "Stock Transfer"){
          return const StockTransferScreen();
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

  DrawerItem? selectedParentItem;
  String? selectedChildItem;
  bool isExpanded = false;

  void selectParent(DrawerItem item) {
    selectedParentItem = item;
    selectedChildItem = null;
    isExpanded = hasVisibleChildren(item);
    update(['drawer_menu']);
  }




  void selectChild(DrawerItem parent, String child) {
    if (selectedChildItem != child) {
      selectedParentItem = parent;
      selectedChildItem = child;
      _updateMenuSelection();
    }
  }

  void _updateMenuSelection() {
    selectedMenuItem.value = MenuSelection(
      parent: selectedParentItem!,
      child: selectedChildItem,
    );
    update(['drawer_menu']);
    // closeDrawer();
  }

  bool hasVisibleChildren(DrawerItem item) {
    if (item == DrawerItems.inventory) {
      return inventoryModule.isNotEmpty;
    } else if (item == DrawerItems.purchase) {
      return purchaseModule.isNotEmpty;
    } else if (item == DrawerItems.returnAndExchange) {
      return true; // Always has Return/Exchange
    }
    return false; // Other menu items have no children
  }

}
