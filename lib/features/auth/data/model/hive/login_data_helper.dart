import 'package:amar_pos/features/auth/presentation/ui/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'login_data.dart';

class LoginDataBoxManager {
  static const String logInBoxName = "loginDataBox";
  static const String logInKey = "login"; // KEY for login object in box

  static final LoginDataBoxManager _instance = LoginDataBoxManager._internal();

  factory LoginDataBoxManager() {
    return _instance;
  }

  ValueListenable<Box> get listenable => _box.listenable();

  LoginDataBoxManager._internal();

  static void init() {
    if (!Hive.isAdapterRegistered(LoginDataAdapter().typeId)) {
      Hive.registerAdapter(LoginDataAdapter());
    }
    if (!Hive.isAdapterRegistered(BusinessAdapter().typeId)) {
      Hive.registerAdapter(BusinessAdapter());
    }
    if (!Hive.isAdapterRegistered(SubscriptionAdapter().typeId)) {
      Hive.registerAdapter(SubscriptionAdapter());
    }
    if (!Hive.isAdapterRegistered(StoreAdapter().typeId)) {
      Hive.registerAdapter(StoreAdapter());
    }
    if (!Hive.isAdapterRegistered(CashHeadAdapter().typeId)) {
      Hive.registerAdapter(CashHeadAdapter());
    }
  }

  late Box<LoginData> _box;

  Future<void> initBox() async {
    try {
      _box = await Hive.openBox<LoginData>(logInBoxName);
    } catch (e) {
      debugPrint("❌ Hive box initialization failed: $e");
      // Handle corrupted box (optional)
      await Hive.deleteBoxFromDisk(logInBoxName);
      _box = await Hive.openBox<LoginData>(logInBoxName);
      Get.offAllNamed(LoginScreen.routeName);
    }
  }

  /// Getter for LoginData
  LoginData? get loginData {
    return _box.get(logInKey);
  }

  /// Setter for LoginData
  set loginData(LoginData? data) {
    if (data != null) {
      _box.put(logInKey, data);
    } else {
      _box.delete(logInKey);
    }
  }

  /// For external access to the box
  Box<LoginData> get box => _box;
}
