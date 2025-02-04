import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import 'package:sparkd/api_repository/api_class.dart';
import 'package:sparkd/api_repository/api_function.dart';
import 'package:sparkd/core/constants/app_strings.dart';
import 'package:sparkd/core/constants/constants.dart';
import 'package:sparkd/pages/auth/login/login_controller.dart';
import 'package:sparkd/pages/auth/login/login_response.dart';
import 'package:sparkd/pages/payment/payment_plan/payment_plan_controller.dart';
import 'package:sparkd/routes/app_pages.dart';

import '../../../main.dart';
import '../../../models/error_response.dart';

class SignupController extends GetxController {
  String? gender;
  String? ageRange;
  RxString otp = "".obs;
  String? personalityType;
  TextEditingController userNameController = TextEditingController();
    TextEditingController lastName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  // final PaymentPlanController _paymentPlanController =
  //     getPaymentPlanController();
  RxBool areFieldsFilled = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();

  //   // Listen to text field changes and update `areFieldsFilled`
  //   userNameController.addListener(_checkFields);
  //   lastName.addListener(_checkFields);
  //   emailController.addListener(_checkFields);
  //   passwordController.addListener(_checkFields);
  // }

  void _checkFields() {
    // Check if all fields are filled and update the RxBool
    areFieldsFilled.value = userNameController.text.isNotEmpty &&
        lastName.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }
  void handleNavigation() {
    // _paymentPlanController.isUserSubscribedToProduct((p0) {
    //   print("${emailController.text} payment for signup calling");
    //   Map chatmsg = {
    //     "name": "${emailController.text} payment for signup calling"
    //   };
    //   Constants.socket!.emit("logEvent", chatmsg);
    //   if (p0 == true) {
    //     Map chatmsg = {
    //       "name":
    //           "${emailController.text} payment verification done ....... DashBoard"
    //     };
    //     Constants.socket!.emit("logEvent", chatmsg);
    //     Get.offNamed(Routes.DASHBOARD);
    //   } else {
    //     Map chatmsg = {
    //       "name":
    //           " ${emailController.text} payment verification done ....... PayWall"
    //     };
    //     Constants.socket!.emit("logEvent", chatmsg);
    //     Get.offNamed(Routes.PAYMENT_PLAN);
    //   }
    // });
  }

  @override
  void onInit() {
      userNameController.addListener(_checkFields);
    lastName.addListener(_checkFields);
    emailController.addListener(_checkFields);
    passwordController.addListener(_checkFields);
    if (Get.arguments != null) {
      gender = Get.arguments[HttpUtil.gender].toString();
      ageRange = Get.arguments[HttpUtil.age].toString();
      personalityType = Get.arguments[HttpUtil.personalityType].toString();
    }
    super.onInit();
  }

  void onLogin() {
    Get.offNamed(Routes.LOGIN);
  }

  Future<void> onSignup() async {
    if (isSignUpValidation()) {
      var json = {
        HttpUtil.name: userNameController.text.trim(),
        HttpUtil.authProvider: "",
        HttpUtil.email: emailController.text.trim(),
        HttpUtil.password: passwordController.text.trim(),
        HttpUtil.gender: gender,
        HttpUtil.age: ageRange,
        HttpUtil.personalityType: personalityType,
        HttpUtil.profileImageUrl: "",
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.signUp,
        withOutFormData: jsonEncode(json),
      );
      Map chatmsg = {"name": "${emailController.text} Singup API Called "};
      Constants.socket!.emit("logEvent", chatmsg);
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        Map chatmsg = {
          "name": "${emailController.text} Singup User data store in DTO Model "
        };
        Constants.socket!.emit("logEvent", chatmsg);
        if (mainModel.success!) {
          getStorageData.saveLoginData(mainModel);
          handleNavigation();
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        Map chatmsg = {
          "name":
              "${emailController.text} SingupApi Error:::${errorModel.message} "
        };
        Constants.socket!.emit("logEvent", chatmsg);
        utils.showToast(message: errorModel.message!);
      }
    }
  }

  Future<void> emailVerification() async {
    if (isEmailValidation()) {
      var json = {
        HttpUtil.email: emailController.text.trim(),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.sendOTPforEmail,
        withOutFormData: jsonEncode(json),
      );
      Map chatmsg = {
        "name": "${emailController.text} Email Verification Api call"
      };
      Constants.socket!.emit("logEvent", chatmsg);
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
   
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        Map chatmsg = {
          "name":
              "Email Verification Api Error :::${emailController.text},,,,,,,,,${errorModel.message}"
        };
        Constants.socket!.emit("logEvent", chatmsg);
        utils.showToast(message: errorModel.message!);
      }
    }
  }

  Future<void> emailVerifi() async {
    if (isSignUpValidation()) {
      var json = {
        HttpUtil.email: emailController.text.trim(),
      };
      print("this is request body$json");
      final data = await APIFunction().apiCall(
        apiName: Constants.sendOTP,
        withOutFormData: jsonEncode(json),
      );
      Map chatmsg = {"name": "Email Verification called"};
      Constants.socket!.emit("logEvent", chatmsg);
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
          utils.showToast(message: "Email already exist");
        } else {
        
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        Map chatmsg = {
          "name": "Email Verification Api Error ::: ${errorModel.message}"
        };
        Constants.socket!.emit("logEvent", chatmsg);
        utils.showToast(message: errorModel.message!);
      }
    }
  }

  bool isEmailValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(emailController.text)) {
      utils.showToast(message: AppStrings.errorEmail);
      return false;
    } else if (!utils.emailValidator(emailController.text)) {
      utils.showToast(message: AppStrings.errorValidEmail);
      return false;
    }
    return true;
  }

  Future<void> socialSignup(SocialLoginModel socialLoginModel) async {
    var json = {
      HttpUtil.name: socialLoginModel.name,
      HttpUtil.authProvider: socialLoginModel.authProvider,
      HttpUtil.email: socialLoginModel.emailID,
      HttpUtil.password: "",
      HttpUtil.gender: gender,
      HttpUtil.age: ageRange,
      HttpUtil.personalityType: personalityType,
      HttpUtil.profileImageUrl: socialLoginModel.profile_image_url,
    };
    final data = await APIFunction().apiCall(
      apiName: Constants.signUp,
      withOutFormData: jsonEncode(json),
    );
    Map chatmsg = {
      "name": "${socialLoginModel.emailID} Social Login API  call"
    };
    Constants.socket!.emit("logEvent", chatmsg);
    try {
      LoginResponse mainModel = LoginResponse.fromJson(data);
      Map chatmsg = {
        "name":
            "${socialLoginModel.emailID}  Socail Login API Data store in DTO Model"
      };
      Constants.socket!.emit("logEvent", chatmsg);
      if (mainModel.success!) {
        emailController.text = socialLoginModel.emailID ?? "";
        handleNavigation();
      } else {
        utils.showToast(message: mainModel.message!);
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      Map chatmsg = {
        "name":
            "${socialLoginModel.emailID}  Socail Login API Error ::::: ${errorModel.message}"
      };
      Constants.socket!.emit("logEvent", chatmsg);
      utils.showToast(message: errorModel.message!);
    }
  }

  bool isSignUpValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(userNameController.text)) {
      utils.showToast(message: AppStrings.errorUsername);
      return false;
    } else if (utils.isValidationEmpty(emailController.text)) {
      utils.showToast(message: AppStrings.errorEmail);
      return false;
    } else if (!utils.emailValidator(emailController.text)) {
      utils.showToast(message: AppStrings.errorValidEmail);
      return false;
    } else if (utils.isValidationEmpty(passwordController.text)) {
      utils.showToast(message: AppStrings.errorEmptyPassword);
      return false;
    }
    return true;
  }

  GoogleSignInAccount? _currentUser;
  RxString appleId = "".obs;
  RxString userName = "".obs;
  RxString userEmail = "".obs;
  final GoogleSignIn? googleSignIn = GoogleSignIn();

  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        _currentUser = googleUser;
        SocialLoginModel socialLoginModel = SocialLoginModel(
          emailID: _currentUser!.email,
          name: _currentUser!.displayName ?? "",
          authProvider: "GOOGLE",
          profile_image_url: _currentUser!.photoUrl ?? "",
        );
        await socialSignup(socialLoginModel);
        update();
      } else {
        // User canceled the login, show a dialog or a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In was cancelled by the user")),
        );
      }

      if (_currentUser != null) {
        await GoogleSignIn().signOut();
      }
    } catch (e) {
      print("Google Sign-In failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
      );
      return null;
    }
    return null;
  }

  Future<String> signInWithApple(BuildContext context) async {
    try {
      final AuthorizationResult result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          if (result.credential != null) {
            userName.value =
                "${result.credential!.fullName?.familyName ?? ""} ${result.credential!.fullName?.givenName ?? ""}";
            appleId.value = result.credential!.user ?? "";
            userEmail.value = result.credential!.email ?? "";

            SocialLoginModel socialLoginModel = SocialLoginModel(
              emailID: userEmail.value,
              name: userName.value,
              authProvider: "APPLE",
              profile_image_url: "", // Update with appropriate value
            );
            await socialSignup(socialLoginModel);
          }
          break;

        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error!.localizedDescription}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Apple Sign-In failed: ${result.error!.localizedDescription}")),
          );
          break;

        case AuthorizationStatus.cancelled:
          print('User cancelled');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Apple Sign-In was cancelled by the user")),
          );
          break;
      }
    } catch (e) {
      print("Apple Sign-In failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Apple Sign-In failed: $e")),
      );
    }

    return "";
  }
}
