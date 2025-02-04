import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/home/home_controller.dart';
import 'package:sparkd/widgets/chat_bubble.dart';
import 'package:sparkd/widgets/lines_widget.dart';

import 'sparkd_lines_response_controller.dart';

class SparkdLinesResponsePage extends StatelessWidget {
  const SparkdLinesResponsePage({super.key});

  @override
  
  Widget build(BuildContext context) {
    bool fetchRequest=false;
    return GetBuilder<SparkdLinesResponseController>(
        init: SparkdLinesResponseController(),
        builder: (controller) {
          return Scaffold(
            appBar: SimpleAppBar(
              title: "Sparkd Coach",
            ),
            body: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      LinesWidget(
                        data: controller.message ??
                            SparkLinesModel(text: "For a new date"),
                        enableTap: false,
                      ),
                      Expanded(
                          child: ListView.builder(
                        controller: controller.scrollController,
                        reverse: true,
                        itemBuilder: (context, index) {
                          var tempList = controller.chatList.reversed.toList();
                          return ChatBubble(
                            disablebutton: "disable",
                              chatItem: tempList[index],
                              regenerate: () {
                                controller.showPrefetchedMessage();
                              });
                        },
                        itemCount: controller.chatList.length,
                      )),
                    ],
                  ).paddingOnly(
                      left: context.paddingDefault,
                      right: context.paddingDefault,
                      top: context.paddingDefault),
                ),
               SafeArea(
                child: Obx(() {
                  return AppButton.primary(
                    title: controller.isFetching.value ? "Loading..." : AppStrings.giveMeLine,
                    onPressed: () {
                      // If preserved data is available, add immediately, otherwise fetch
                      controller.showPrefetchedMessage();
                    },
                  ).paddingSymmetric(horizontal: 20, vertical: 10);
                }),
              ),
              ],
            ),
          );
        });
  }
}
