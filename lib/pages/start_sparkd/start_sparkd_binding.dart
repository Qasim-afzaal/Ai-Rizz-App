import 'package:get/get.dart';
import 'package:sparkd/pages/start_sparkd/start_sparkd_controller.dart';

class StartSparkdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartSparkdController>(
      () => StartSparkdController(),
    );
  }
}
