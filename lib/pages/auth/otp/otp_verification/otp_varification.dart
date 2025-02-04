import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/auth/otp/otp_verification/otp_verification_controller.dart';

class OTPVerificationPage extends StatelessWidget {
  const OTPVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OtpVerificationController>(
        init: OtpVerificationController(),
        builder: (controller) {
          return Scaffold(
            appBar: const SimpleAppBar(
              title: "Otp Verification",
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
                          controller.email!.toString(),
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
                    SB.h(context.height * 0.02),
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
                    ),
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
