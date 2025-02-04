import 'package:get/get.dart';

import 'package:sparkd/pages/start/create_account/create_account_controller.dart';

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAccountController>(
      () => CreateAccountController(),
    );
  }
}
