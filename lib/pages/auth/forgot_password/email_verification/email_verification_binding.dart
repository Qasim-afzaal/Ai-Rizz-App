import 'package:get/get.dart';
import 'package:sparkd/pages/auth/forgot_password/email_verification/email_verification_controller.dart';

class EmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerificationController>(
      () => EmailVerificationController(),
    );
  }
}
