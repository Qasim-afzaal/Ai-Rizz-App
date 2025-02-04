import 'package:get/get.dart';
import 'package:sparkd/pages/sparkd_lines/sparkd_lines_controller.dart';

class SparkdLinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SparkdLinesController>(
      () => SparkdLinesController(),
    );
  }
}
