import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/features/home/presentation/home_screen_controller.dart';
import 'package:get/get.dart';
import 'features/permission/permissions.dart';

class PermissionManager{
  static  Map<String, Map<String, String>> _permissions = {};


  static Future<void> loadPermissions() async {
    HomeScreenController homeScreenController = Get.find();
    logger.e(homeScreenController.permissionApiResponse?.data);
    _permissions = homeScreenController.permissionApiResponse!.data;
  }

  static bool hasPermission(String permission) {
    for (var module in _permissions.values) {
      if (module.containsKey(permission)) {
        return true;
      }
    }
    return false;
  }

  static bool hasAnyPermission(List<String> requiredPermissions) {
    logger.i(_permissions);
    return requiredPermissions.any((permission) => hasPermission(permission));
  }

  static bool hasAllPermissions(List<String> requiredPermissions) {
    return requiredPermissions.every((permission) => hasPermission(permission));
  }

  static bool hasParentPermission(String permission) {
    // Extract parent module name (e.g., "PurchaseOrder" from "PurchaseOrder.store")
    return _permissions.containsKey(permission);
  }
}