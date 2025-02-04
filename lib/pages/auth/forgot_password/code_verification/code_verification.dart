import 'package:sparkd/core/constants/imports.dart';

import 'code_verification_controller.dart';

class CodeVerificationPage extends StatelessWidget {
  const CodeVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CodeVerificationController>(
        init: CodeVerificationController(),
        builder: (controller) {
          return Scaffold(
            appBar: SimpleAppBar(
              title: controller.isForgetPin
                  ? AppStrings.forgotPin
                  : AppStrings.forgotPassword,
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    SB.h(30),
                    Text(
                      AppStrings.verifyYourMail,
                      textAlign: TextAlign.center,
                      style: context.headlineMedium?.copyWith(
                        color: context.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SB.h(20),
                    Text(
                      AppStrings.verifyYourMailDescription +
                          controller.emailValue!.toString(),
                      textAlign: TextAlign.center,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SB.h(30),
                    Text(
                      "The code in the email will only be valid for 10 minutes.\nBe sure to also check your spam folder.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ).paddingAll(5),
                    SB.h(context.height * 0.05),
                    CustomTextField(
                      controller: controller.otpController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLength: 4,
                    ),
                    SB.h(5),
                    AppButton.primary(
                      title: AppStrings.verify,
                      onPressed: controller.codeVerification,
                    )
                  ],
                ).paddingAll(context.paddingDefault),
              ),
            ),
          );
        },
      ),
    );
  }
}
