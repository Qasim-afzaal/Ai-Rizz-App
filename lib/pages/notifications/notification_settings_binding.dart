import 'package:get/get.dart';
import 'package:sparkd/pages/notifications/notification_settings_controller.dart';

class NotificationSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationSettingsController>(
      () => NotificationSettingsController(),
    );
  }
}
