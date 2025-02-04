import 'package:get/get.dart';
import 'package:sparkd/pages/pin/create_pin/create_pin_controller.dart';

class CreatePinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePinController>(
      () => CreatePinController(),
    );
  }
}
