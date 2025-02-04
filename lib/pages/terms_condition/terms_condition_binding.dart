import 'package:get/get.dart';
import 'package:sparkd/pages/terms_condition/terms_condition_controller.dart';

class TermsConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsConditionController>(
      () => TermsConditionController(),
    );
  }
}
