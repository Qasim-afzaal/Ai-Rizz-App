import 'package:get/get.dart';
import 'package:sparkd/pages/inbox/inbox_controller.dart';

class InboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InboxController>(
      () => InboxController(),
    );
  }
}
