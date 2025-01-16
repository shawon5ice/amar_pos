import 'package:amar_pos/features/auth/presentation/controller/auth_controller.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> DrawerMenuController());
  }

}


class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> AuthController());
  }
}

class ProductsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProductController());
  }
}

class AddProductBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProductController());
  }
}