import 'package:amar_pos/core/constants/logger/logger.dart';

import 'features/auth/data/model/hive/login_data.dart';
import 'features/auth/data/model/hive/login_data_helper.dart';

class PermissionManager{
  static Set<String> _permissions = {};

  static Future<void> loadPermissions() async {
    LoginData? loginData = LoginDataBoxManager().loginData;
    _permissions = Set<String>.from(loginData!.permissions);
  }

  static bool hasPermission(String permission) {
    return _permissions.contains(permission);
  }

  static bool hasAnyPermission(List<String> requiredPermissions) {
    logger.i(_permissions);
    return requiredPermissions.any((permission) => _permissions.contains(permission));
  }

  static bool hasAllPermissions(List<String> requiredPermissions) {
    return requiredPermissions.every((permission) => _permissions.contains(permission));
  }

  static bool hasParentPermission(String permission) {
    // Extract parent module name (e.g., "PurchaseOrder" from "PurchaseOrder.store")
    String? moduleName = permission.split('.').firstOrNull;
    if (moduleName == null) return false;

    // Check if any permission in _permissions starts with the module name
    return _permissions.any((p) => p.startsWith(moduleName));
  }

}