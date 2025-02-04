import 'package:get/get.dart';
import 'package:sparkd/pages/auth/pin_verification/pin_verification_controller.dart';

class PinVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinVerificationController>(
      () => PinVerificationController(),
    );
  }
}
