import 'package:get/get.dart';
import 'package:sparkd/pages/settings/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {


    Get.lazyPut<SettingsController>(
          () => SettingsController(inAppPurchaseSource: Get.find()),
    );
  }
}