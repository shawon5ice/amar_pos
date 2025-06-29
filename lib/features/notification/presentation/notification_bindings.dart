import 'package:get/get.dart';
import 'notification_controller.dart';

class NotificationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}