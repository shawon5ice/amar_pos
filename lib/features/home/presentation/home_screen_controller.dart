import 'package:amar_pos/features/home/data/models/dashboard_response_model.dart';
import 'package:amar_pos/features/home/presentation/home_screen_service.dart';
import 'package:amar_pos/features/permission/permissions.dart';
import 'package:amar_pos/permission_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/logger/logger.dart';
import '../../accounting/presentation/views/due_collection/due_collection.dart';
import '../../accounting/presentation/views/expense_voucher/expense_voucher.dart';
import '../../accounting/presentation/views/money_transfer/money_transfer.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import '../../drawer/drawer_menu_controller.dart';
import '../../drawer/model/drawer_items.dart';
import '../../drawer/model/menu_selection.dart';
import '../data/models/quick_access_item_model.dart';

class HomeScreenController extends GetxController{

  DrawerMenuController drawerMenuController = Get.find();
  RxBool permissionLoading = false.obs;

  bool firstTime = true;

  PermissionApiResponse? permissionApiResponse;
  Future<void> getPermissions() async {
    permissionLoading = true.obs;
    if(firstTime){
      // EasyLoading.show();
      firstTime = false;
    }
    update(['permissions_loading']);
    try{
      var response = await HomeScreenService.getPermissions(usrToken: LoginDataBoxManager().loginData!.token);
      if (response != null) {
        permissionApiResponse = PermissionApiResponse.fromJsonForGroupData(response);
        await PermissionManager.loadPermissions();
        await buildQuickAccessButtonList();
        await drawerMenuController.loadModules();
      }
    }catch(e){
      logger.e(e);
    }finally{
      permissionLoading = false.obs;
      // EasyLoading.dismiss();
    }

  }

  bool dashboardDataLoading = false;
  DashboardResponseModel? dashboardResponseModel;

  bool firstTimeLoading = false;

  Future<void> getDashboardData() async {
    if(!firstTimeLoading){
      dashboardDataLoading = true;
      firstTimeLoading = true;
    }
    update(['dashboard_data']);
    try{
      var response = await HomeScreenService.getDashboardData(usrToken: LoginDataBoxManager().loginData!.token);
      if (response != null) {
        dashboardResponseModel = DashboardResponseModel.fromJson(response);
      }
    }catch(e){
      logger.e(e);
    }finally{
      dashboardDataLoading = false;
      update(['dashboard_data']);
    }

  }

  final List<QuickAccessItemModel> quickAccessItems = [];

  Future<void> buildQuickAccessButtonList() async {
    quickAccessItems.clear();
    PermissionManager.hasParentPermission("Order");
    quickAccessItems.addIf( PermissionManager.hasParentPermission("Order"),QuickAccessItemModel(
      isLoading: dashboardDataLoading,
      title: "Create Invoice",
      asset: AppAssets
          .createInvoiceQuickAccessIcon,
      onPress: (){
        drawerMenuController.selectMenuItem(MenuSelection(parent: DrawerItems.sales,child: 'Sales'));
      },
    ),);

    quickAccessItems.addIf( PermissionManager.hasParentPermission("OrderReturn"),QuickAccessItemModel(
      isLoading:dashboardDataLoading,
      title: "Create Return",
      asset: AppAssets
          .createReturnQuickAccessIcon,
      onPress: (){
        drawerMenuController.selectMenuItem(MenuSelection(parent: DrawerItems.returnAndExchange,child: 'Return'));
      },
    ),);

    quickAccessItems.addIf( PermissionManager.hasParentPermission("BalanceTransfer"),QuickAccessItemModel(
      isLoading:
      dashboardDataLoading,
      title: "Cash Transfer",
      asset: AppAssets
          .cashTransferQuickAccessIcon,
      onPress: (){
        Get.toNamed(MoneyTransfer.routeName);
      },
    ),);

    quickAccessItems.addIf( PermissionManager.hasParentPermission("Journal"),QuickAccessItemModel(
      isLoading:
      dashboardDataLoading,
      title: "Expense",
      asset: AppAssets
          .expense,
      onPress: (){
        Get.toNamed(ExpenseVoucher.routeName);
      },
    ),);

    quickAccessItems.addIf( PermissionManager.hasParentPermission("MoneyReceipt"),
      QuickAccessItemModel(
        isLoading:
        dashboardDataLoading,
        title: "Collect Due",
        asset: AppAssets
            .collection,
        onPress: (){
          Get.toNamed(DueCollection.routeName);
        },
      ),);
    update(['dashboard_data']);
  }

  List<List<QuickAccessItemModel>> chunkList(int size) {
    List<List<QuickAccessItemModel>> chunks = [];
    for (int i = 0; i < quickAccessItems.length; i += size) {
      chunks.add(quickAccessItems.sublist(i, i + size > quickAccessItems.length ? quickAccessItems.length : i + size));
    }
    return chunks;
  }
}