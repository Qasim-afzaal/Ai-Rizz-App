import 'package:sparkd/core/constants/imports.dart';

import 'create_password_controller.dart';

class CreatePasswordPage extends StatelessWidget {
  const CreatePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CreatePasswordController>(
        init: CreatePasswordController(),
        builder: (controller) {
          return Scaffold(
            appBar: SimpleAppBar(
              title: controller.isForgetPin ? AppStrings.forgotYourPin : AppStrings.forgotPassword,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SB.h(30),
                  Text(
                    controller.isForgetPin ? AppStrings.createNewPin : AppStrings.createNewPassword,
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(context.height * 0.05),
                  CustomTextField(
                    controller: controller.newPassword,
                    title: controller.isForgetPin ? AppStrings.enterPin : AppStrings.enterNewPassword,
                    isPasswordField: true,
                    maxLength: controller.isForgetPin ? 4 : null,
                  ),
                  CustomTextField(
                    controller: controller.confirmNewPassword,
                    title: controller.isForgetPin ? AppStrings.confirmPin : AppStrings.confirmPassword,
                    isPasswordField: true,
                    maxLength: controller.isForgetPin ? 4 : null,
                    textInputAction: TextInputAction.done,
                  ),
                  SB.h(20),
                  AppButton.primary(
                    title: controller.isForgetPin ? AppStrings.confirmPin : AppStrings.confirmPassword,
                    onPressed: controller.isForgetPin ? controller.changePin : controller.changePassword,
                  )
                ],
              ).paddingAll(context.paddingDefault),
            ),
          );
        },
      ),
    );
  }
}
