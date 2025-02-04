import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/new_chat/gather_new_chat/gather_new_chat_info_controller.dart';

class NameWidget extends StatelessWidget {
  const NameWidget({super.key, required this.controller});
  final GatherNewChatInfoController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.allSet,
          style: context.headlineMedium?.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SB.h(10),
        Text(
          AppStrings.allSetDescription,
          textAlign: TextAlign.center,
          style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w400, height: 1),
        ),
        SB.h(40),
        CustomTextField(
          controller: controller.nameController,
          title: AppStrings.name,
        ),
        SB.h(25),
        AppButton.primary(
          title: AppStrings.getMySparkd,
          onPressed: controller.getSparkd,
        )
      ],
    ).paddingAll(context.paddingDefault);
  }
}
