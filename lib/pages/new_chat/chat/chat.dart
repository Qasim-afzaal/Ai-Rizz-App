import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/new_chat/chat/chat_controller.dart';
import 'package:sparkd/pages/new_chat/voice_chat/voice_chat.dart';
import 'package:sparkd/widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ChatController(),
        builder: (controller) {
          return Scaffold(
            appBar: SimpleAppBar(
              title: controller.name,
            ),
            body: Column(
              children: [
                Obx(() => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      ).marginSymmetric(vertical: 10.0)
                    : const SizedBox()),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var tempList = controller.chatList.reversed.toList();
                      return Column(
                        crossAxisAlignment: tempList[index].isReceived
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          ChatBubble(
                            chatItem: tempList[index],
                            regenerate: () {
                              controller.regenerateMessage(tempList[index]);
                            },
                          ),
                        ],
                      );
                    },
                    // separatorBuilder: (context, index) {
                    //   return SB.h(15);
                    // },
                    controller: controller.scrollController,
                    itemCount: controller.chatList.length,
                    reverse: true,
                  ).paddingOnly(
                      top: context.paddingDefault / 2,
                      left: context.paddingDefault,
                      right: context.paddingDefault),
                ),
                SafeArea(
                    child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        minLines: 1,
                        textCapitalization: 
                       TextCapitalization.sentences,
                        maxLines: 8,
                        controller: controller.textController,
                        prefixIcon: InkWell(
                          onTap: () {
                            utils.openImagePicker(
                              context,
                              onPicked: (pickFile) {
                                pickFile.forEach((element) async {
                                  controller.imagePath = element;
                                  // Get.back();
                                  controller.uploadImage();
                                });
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              Assets.icons.attachments.path,
                              //  color: context.grey,
                            ),
                          ),
                        ),
                        hintText: AppStrings.enterYourText,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.primary,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.textController.text
                                          .trim()
                                          .isNotEmpty) {
                                        controller.chatList.add(
                                          MessageModel(
                                              message: controller
                                                  .textController.text
                                                  .trim(),
                                              messageType: MessageType.text,
                                              isReceived: false,
                                              messageId: ""),
                                        );
                                        controller.update();
                                        controller.sendMessage(
                                            controller.textController.text
                                                .trim(),
                                            "");
                                        controller.textController.text = "";
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      Assets.icons.send.path,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).paddingSymmetric(horizontal: 20),
                    ),
                    // InkWell(onTap: () => Get.to(() => const VoiceChatPage()), child: Assets.icons.headphone.svg().paddingAll(8)).paddingOnly(bottom: 15),
                  ],
                ))
              ],
            ),
          );
        });
  }
}
