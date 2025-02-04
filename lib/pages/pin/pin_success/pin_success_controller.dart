import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/profile/profile_controller.dart';

class PinSuccessController extends GetxController {
  void backToProfile() {
    Get.find<ProfileController>().update();
    Get.back();
  }
}
