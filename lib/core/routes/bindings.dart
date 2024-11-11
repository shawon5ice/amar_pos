import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> DrawerMenuController());
  }

}