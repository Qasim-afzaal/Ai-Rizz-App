import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sparkd/core/components/app_button.dart';
import 'package:sparkd/core/constants/app_strings.dart';
import 'package:sparkd/routes/app_pages.dart';

import 'first_screen_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<MainPageController>(
      init: MainPageController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              // GIF Background
              Positioned.fill(
                child: Image.asset(
                  "assets/images/gif.GIF",
                  fit: BoxFit.cover,
                ).animate().fade(duration: 800.ms), // Smooth fade-in animation
              ),

              // Foreground Content
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: screenWidth * 0.7,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "30 Day free trial / \$3.99 per week",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Login Buttons
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                            child: controller.showSocialLogin
                                ? Column(
                                    key: const ValueKey("socialLogin"),
                                    children: [
                                      socialLoginButton(
                                        imagePath: "assets/icons/apple.svg",
                                        text: "Login with Apple",
                                        onPressed: () {
                                          Get.offNamed(Routes.PAYMENT_PLAN);
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      socialLoginButton(
                                        imagePath: "assets/icons/google.svg",
                                        text: "Login with Google",
                                        onPressed: () {
                                          Get.offNamed(Routes.PAYMENT_PLAN);
                                        },
                                      ),
                                      AppButton.primary(
                                        title: "Login with Email",
                                        onPressed: () {
                                          Get.offNamed(Routes.PAYMENT_PLAN);
                                        },
                                      ).paddingAll(16.0),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: controller.toggleLogin,
                                        child: const Text(
                                          "Back",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    key: const ValueKey("mainButtons"),
                                    children: [
                                      AppButton.primary(
                                        title: AppStrings.createAccount,
                                        onPressed: () {
                                          Get.toNamed(Routes.SIGN_UP);
                                        },
                                      ).paddingAll(16.0),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: controller.toggleLogin,
                                        child: const Text(
                                          "Login",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Social Login Button Widget
Widget socialLoginButton({
  required String imagePath,
  required String text,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              imagePath,
              height: 20,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
