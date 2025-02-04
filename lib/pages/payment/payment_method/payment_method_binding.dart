import 'package:get/get.dart';
import 'package:sparkd/pages/payment/payment_method/payment_method_controller.dart';

class PaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentMethodController>(
      () => PaymentMethodController(),
    );
  }
}
