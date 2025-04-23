import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'login_data.dart';

class LoginDataBoxManager {
  static const String logInBoxName = "loginDataBox";
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
  }

  late Box _box;

  Future<void> initBox() async {
    _box = await Hive.openBox(logInBoxName);
  }

  LoginData? get loginData {
    return _box.get(logInBoxName);
  }

  /// Setter for LoginData
  set loginData(LoginData? loginData) {
    if (loginData != null) {
      _box.put(logInBoxName, loginData);
    } else {
      _box.delete(logInBoxName);
    }
  }


  Box get box => _box;
}