
import 'package:google_fonts/google_fonts.dart';

import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/pages/auth/signup/signup_controller.dart';
import 'package:sparkd/routes/app_pages.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/onboarding.png', // Change to your image path
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.orange),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Text(
                                "Sign up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(Icons.arrow_back,
                                  color: Colors.transparent),
                            ],
                          ),
                          SB.h(25),
                          CustomTextField(
                            controller: controller.userNameController,
                            title: "First Name",
                            hintText: AppStrings.enterName,
                          ),
                          CustomTextField(
                            controller: controller.lastName,
                            title: "Last Name",
                            hintText: AppStrings.enterName,
                          ),
                          CustomTextField(
                            controller: controller.emailController,
                            title: AppStrings.email,
                            hintText: AppStrings.enterEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          CustomTextField(
                            controller: controller.passwordController,
                            title: AppStrings.password,
                            hintText: AppStrings.enterPassword,
                            textInputAction: TextInputAction.done,
                            isPasswordField: true,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SB.h(15),
                          const Text(
                            "30 Day free trial / \$3.99 per week",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SB.h(15),
                          // Conditionally show either the social login button or the app button
                          Obx(() {
                            return controller.areFieldsFilled.value
                                ? AppButton.primary(
                                    title: "Create account",
                                    onPressed: () async {
                                      Get.offNamed(Routes.PAYMENT_PLAN);
                                    },
                                  )
                                : socialLoginButton(
                                    onPressed: () {},
                                    text: "Create account",
                                  );
                          }),
                          SB.h(15),
                          const Text(
                            "Subscriptions will renew unless cancelled in your app store settings",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                       
                        ],
                      ),
                    ],
                  ).paddingAll(context.paddingDefault),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget socialLoginButton({
  required String text,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: 50,
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
