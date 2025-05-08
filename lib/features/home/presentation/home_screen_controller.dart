import 'package:amar_pos/features/home/data/models/dashboard_response_model.dart';
import 'package:amar_pos/features/home/presentation/home_screen_service.dart';
import 'package:amar_pos/features/permission/permissions.dart';
import 'package:amar_pos/permission_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../core/constants/logger/logger.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import '../../drawer/drawer_menu_controller.dart';

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
      logger.i(response);
      if (response != null) {
        dashboardResponseModel = DashboardResponseModel.fromJson(response);
        logger.d(dashboardResponseModel?.dashboardResponseData.balance);
      }
    }catch(e){
      logger.e(e);
    }finally{
      dashboardDataLoading = false;
      update(['dashboard_data']);
    }

  }
}