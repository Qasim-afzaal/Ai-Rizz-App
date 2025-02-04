import 'package:sparkd/core/constants/imports.dart';

import 'email_verification_controller.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EmailVerificationController>(
        init: EmailVerificationController(),
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
                    AppStrings.verification,
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SB.h(5),
                  Text(
                    AppStrings.verificationDescription,
                    textAlign: TextAlign.center,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SB.h(context.height * 0.1),
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: AppStrings.enterEmail,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                  SB.h(20),
                  AppButton.primary(
                    title: AppStrings.send,
                    onPressed: controller.emailVerification,
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
