import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/widgets/age_widget.dart';
import 'package:sparkd/widgets/gender_widget.dart';
import 'package:sparkd/widgets/name_widget.dart';
import 'package:sparkd/widgets/objective_widget.dart';
import 'package:sparkd/widgets/personality_widget.dart';

import 'gather_new_chat_info_controller.dart';

class GatherNewChatInfoPage extends StatelessWidget {
  const GatherNewChatInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GatherNewChatInfoController>(
        init: GatherNewChatInfoController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              if (controller.currentPage.value == 0) {
                return true;
              } else {
                controller.previousPage();
                return false;
              }
            },
            child: Scaffold(
              appBar: SimpleAppBar(
                title: AppStrings.startASparkd,
                onPressed: () {
                  if (controller.currentPage.value == 0) {
                    Get.back();
                  } else {
                    controller.previousPage();
                  }
                },
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SB.h(25),
                    Expanded(
                      child: PageView(
                        controller: controller.pageController,
                        onPageChanged: (index) => controller.currentPage.value = index,
                        children: [
                          ObjectiveWidget(
                            selectedObjective: controller.selectedObjective,
                            onObjectiveSelection: controller.onObjectiveSelection,
                          ),
                          GenderWidget(
                            headingText: AppStrings.theirGenderHeading,
                            selectedGender: controller.selectedGender,
                            onGenderSelection: controller.onGenderSelection,
                          ),
                          AgeWidget(
                            headingText: AppStrings.theirAgeHeading,
                            selectedAge: controller.selectedAgeRange,
                            onAgeSelection: controller.onAgeSelection,
                          ),
                          PersonalityWidget(
                            headingText: AppStrings.theirPersonalityHeading,
                            selectedPersonality: controller.selectedPersonality,
                            onPersonalitySelection: controller.onPersonalitySelection,
                          ),
                          NameWidget(
                            controller: controller,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 5; i++)
                          Obx(
                            () => _PageIndicator(
                              isCurrentPage: controller.currentPage.value == i,
                            ),
                          ),
                      ],
                    ),
                    SB.h(20),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({super.key, this.isCurrentPage = false});

  final bool isCurrentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      height: 6,
      width: (isCurrentPage ? 18 : 10),
      // duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCurrentPage ? null : context.primary.withOpacity(0.25),
        gradient: isCurrentPage
            ? LinearGradient(colors: [
                context.primary,
                context.secondary,
              ])
            : null,
      ),
    );
  }
}
