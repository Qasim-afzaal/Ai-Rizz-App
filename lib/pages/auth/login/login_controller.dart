import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:sparkd/api_repository/api_class.dart';
import 'package:sparkd/api_repository/api_function.dart';
import 'package:sparkd/core/constants/app_globals.dart';
import 'package:sparkd/core/constants/app_strings.dart';
import 'package:sparkd/core/constants/constants.dart';
import 'package:sparkd/pages/auth/login/login_response.dart';
import 'package:sparkd/pages/new_chat/chat/error_response.dart';
import 'package:sparkd/pages/payment/payment_plan/payment_plan_controller.dart';
import 'package:sparkd/routes/app_pages.dart';

import '../../../main.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final PaymentPlanController _paymentPlanController =
  //     getPaymentPlanController();

  void handleNavigation() {
    print("i am here${emailController.text} Recipt Verification.....");
  
    // _paymentPlanController.isUserSubscribedToProduct((p0) {
    //   print("Verification Api Called Status::$p0");
    //   Map msg = {
    //     "name":
    //         " Api Called Navigate base on Status$p0 ..."
    //   };

    //   Constants.socket!.emit("logEvent", msg);
    //   if (p0 == true) {
    //     print("i am here${emailController.text} dashbord.....");
    //     Map msg = {
    //       "name":
    //           "Verification Done Navigate to Dashboad ..."
    //     };
    //     print(
    //         "i am here${emailController.text ?? ""} Recipt Verification.....");
    //     Constants.socket!.emit("logEvent", msg);
    //     Get.offNamed(Routes.DASHBOARD);
    //   } else {
    //     print("i am here${emailController.text} Paywalll.....");
    //     Map msg = {
    //       "name":
    //           " Verification Done Navigate to PayWall ..."
    //     };

    //     Constants.socket!.emit("logEvent", msg);
    //     Get.offNamed(Routes.PAYMENT_PLAN);
    //   }
    // });
  }

  Future<void> onLogin() async {
    if (isLoginValidation()) {
      var json = {
        HttpUtil.email: emailController.text.trim(),
        HttpUtil.password: passwordController.text.trim(),
        HttpUtil.authProvider: "",
      };
      Map dataForTest = {
        "name": "${emailController.text} Login Api calling State"
      };
      Constants.socket!.emit("logEvent", dataForTest);
      final data = await APIFunction().apiCall(
        apiName: Constants.login,
        withOutFormData: jsonEncode(json),
      );
      Map msg = {"name": "${emailController.text} Login Api Called"};
      Constants.socket!.emit("logEvent", msg);
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        Map msg = {
          "name": "${emailController.text} Login user data store in DTO model"
        };
      
        AppGlobals.email = emailController.text;
        Constants.socket!.emit("logEvent", msg);
        if (mainModel.success!) {
          getStorageData.saveLoginData(mainModel);
         Get.offNamed(Routes.PAYMENT_PLAN);
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        Map msg = {
          "name":
              " Login Api error:::::${errorModel.message}"
        };
        Constants.socket!.emit("logEvent", msg);
        utils.showToast(message: errorModel.message!);
      }
    }
  }

  Future<void> socialLogin(SocialLoginModel socialLoginModel) async {
    var json = {
      HttpUtil.email: socialLoginModel.emailID,
      HttpUtil.password: "",
      HttpUtil.authProvider: socialLoginModel.authProvider,
    };

    AppGlobals.email = HttpUtil.email;
    print("i am here${socialLoginModel.emailID} lOGIN x.....");
    Map socialMsg = {
      "name": " Social login in Processing"
    };

    Constants.socket!.emit("logEvent", socialMsg);
    final data = await APIFunction().apiCall(
      apiName: Constants.login,
      withOutFormData: jsonEncode(json),
    );
    Map msg = {"name": "${socialLoginModel.emailID} Social Login Api called"};
    Constants.socket!.emit("logEvent", msg);
    try {
      LoginResponse mainModel = LoginResponse.fromJson(data);
      Map msg = {
        "name":
            "${socialLoginModel.emailID} Social Login User data store in DTO Model"
      };
      Constants.socket!.emit("logEvent", msg);
      if (mainModel.success!) {
        getStorageData.saveLoginData(mainModel);
      } else {
        
        if (HttpUtil.authProvider != "") {
          Get.offNamed(Routes.ON_BOARDING_FOR_SOCIAL, arguments: {
            HttpUtil.name: socialLoginModel.name,
            HttpUtil.email: socialLoginModel.emailID,
            HttpUtil.authProvider: socialLoginModel.authProvider,
          });
        }
      }
    } catch (e) {
      ErrorResponse errorModel = ErrorResponse.fromJson(data);
      Map msg = {
        "name":
            "Socail Login Api Error::::${errorModel.message}"
      };
      Constants.socket!.emit("logEvent", msg);
      utils.showToast(message: errorModel.message!);
    }
  }

  void navigateToSignup() {
    Get.offNamed(Routes.ON_BOARDING);
  }

  bool isLoginValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(emailController.text)) {
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
      await GoogleSignIn().signIn().then((value) {
        _currentUser = value;
        print(">>>>>>>>>>>" + _currentUser.toString());
        SocialLoginModel socialLoginModel = SocialLoginModel(
          emailID: _currentUser!.email.toString(),
          name: _currentUser!.displayName!.toString(),
          authProvider: "GOOGLE",
          profile_image_url: _currentUser!.photoUrl.toString(),
        );

        Map msg = {
          "name":
              "Google Social Login fetching data from google"
        };
        Constants.socket!.emit("logEvent", msg);
        socialLogin(socialLoginModel);
        update();
      });
      if (_currentUser != null) {
        await googleSignIn?.signOut();
      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>> $e");
      return null;
    }
    return null;
  }

  Future<String> signInWithApple(BuildContext context) async {
    try {
      // Get Apple ID credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuth provider
      final oAuthProvider = OAuthProvider("apple.com");
      final authCredential = oAuthProvider.credential(
        idToken: credential.identityToken!,
        accessToken: credential.authorizationCode,
      );

      // Sign in with Firebase using the credential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      final user = userCredential.user;

      // Check if email is null and handle it accordingly
      String email = credential.email ?? user?.email ?? "";
      if (email.isEmpty) {
        // Handle the case where email is not provided
        return "Email not provided";
      }

      // Update user details
      userName.value =
          "${credential.givenName ?? ""} ${credential.familyName ?? ""}";
      appleId.value = user?.uid ?? "";
      userEmail.value = email;
      Map msg = {
        "name": " Apple Social Login fetching data from apple"
      };
      Constants.socket!.emit("logEvent", msg);
      // Prepare the social login model
      SocialLoginModel socialLoginModel = SocialLoginModel(
        emailID: userEmail.value,
        name: userName.value,
        authProvider: "APPLE",
        profile_image_url: user?.photoURL ?? "", // Update if available
      );

      // Handle social login
      await socialLogin(socialLoginModel);

      return "";
    } catch (e) {
      print("Sign in failed: $e");
      return "Sign in failed: $e";
    }
  }
}

class SocialLoginModel {
  String? emailID;
  String? name;
  String? authProvider;
  String? profile_image_url;

  SocialLoginModel({
    this.emailID,
    this.name,
    this.authProvider,
    this.profile_image_url,
  });
}
