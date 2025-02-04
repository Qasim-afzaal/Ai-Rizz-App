import 'package:get/get.dart';
import 'package:sparkd/pages/new_chat/voice_chat/voice_chat_controller.dart';

class VoiceChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceChatController>(
      () => VoiceChatController(),
    );
  }
}
