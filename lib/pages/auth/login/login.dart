import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/widgets/custom_rich_text.dart';

import '../../../api_repository/api_class.dart';
import '../../../routes/app_pages.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Assets.icons.logoBlack
                      .svg()
                      .paddingSymmetric(vertical: context.paddingDefault),
                  Text(
                    AppStrings.welcomeBack,
                    textAlign: TextAlign.center,
                    style: context.headlineMedium?.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SB.h(8),
                  Text(
                    AppStrings.loginDescription,
                    textAlign: TextAlign.center,
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SB.h(35),
                  CustomTextField(
                    controller: controller.emailController,
                    title: AppStrings.email,
                    hintText: AppStrings.enterEmail,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                  CustomTextField(
                    controller: controller.passwordController,
                    title: AppStrings.password,
                    hintText: AppStrings.enterPassword,
                    textInputAction: TextInputAction.done,
                    isPasswordField: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () =>
                          Get.toNamed(Routes.EMAIL_VERIFICATION, arguments: {
                        HttpUtil.isForgetPin: false,
                      }),
                      child: Text(
                        AppStrings.forgotPassword,
                        textAlign: TextAlign.center,
                        style: context.bodyLarge?.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SB.h(25),
                  AppButton.primary(
                    title: AppStrings.login,
                    onPressed: () async {
                      // Check connectivity status before proceeding
                      var connectivityResult =
                          await Connectivity().checkConnectivity();

                      // Print the result for debugging
                      print('Connectivity Result: $connectivityResult');

                      if (connectivityResult != ConnectivityResult.none) {
                        // If internet is available, proceed with the onLogin method
                        controller.onLogin();
                      } else {
                        // No internet connection, show snackbar and stop further execution
                        Get.snackbar(
                          "No Internet",
                          "Please check your internet connection and try again.",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return; // Prevent the method call by returning here
                      }
                    },
                  ),
                  SB.h(context.height * 0.15),
                  CustomRichText(
                    text: AppStrings.notMember,
                    highlightedText: AppStrings.signUp,
                    onTap: controller.navigateToSignup,
                  ),
                  SB.h(context.height * 0.05),
                  Text(
                    AppStrings.orSignupWith,
                    textAlign: TextAlign.center,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SB.h(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton.borderIcon(
                        onTap: () async {
                          // Check connectivity status before proceeding
                              var connectivityResult =
                              await Connectivity().checkConnectivity();

                          // Print the result for debugging
                          print('Connectivity Result: $connectivityResult');

                          if (connectivityResult != ConnectivityResult.none) {
                            // If internet is available, proceed with Google login
                            controller.loginWithGoogle(context);
                          } else {
                            // No internet connection, show snackbar and stop further execution
                            Get.snackbar(
                              "No Internet",
                              "Please check your internet connection and try again.",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return; // Prevent the API call by returning here
                          }
                        },
                        icon: Assets.icons.google.svg(),
                      ),
                      if (Platform.isIOS) ...[
                        SB.w(15),
                        AppButton.borderIcon(
                          onTap: () async {
                            // Check connectivity status before proceeding
                            var connectivityResult =
                                await Connectivity().checkConnectivity();

                            // Print the result for debugging
                            print('Connectivity Result: $connectivityResult');

                            if (connectivityResult != ConnectivityResult.none) {
                              // If internet is available, proceed with the signInWithApple method
                              controller.signInWithApple(context);
                            } else {
                              // No internet connection, show snackbar and stop further execution
                              Get.snackbar(
                                "No Internet",
                                "Please check your internet connection and try again.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return; // Prevent the method call by returning here
                            }
                          },
                          icon: Assets.icons.apple.svg(),
                        ),
                      ]
                    ],
                  )
                ],
              ).paddingAll(context.paddingDefault),
            ),
          ),
        );
      },
    );
  }
}
