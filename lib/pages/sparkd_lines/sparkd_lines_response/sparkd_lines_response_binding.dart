import 'package:get/get.dart';
import 'package:sparkd/pages/sparkd_lines/sparkd_lines_response/sparkd_lines_response_controller.dart';

class SparkdLinesResponseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SparkdLinesResponseController>(
      () => SparkdLinesResponseController(),
    );
  }
}
