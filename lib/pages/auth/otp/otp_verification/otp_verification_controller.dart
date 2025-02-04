import 'dart:convert';

import 'package:sparkd/api_repository/api_class.dart';
import 'package:sparkd/api_repository/api_function.dart';
import 'package:sparkd/core/constants/imports.dart';
import 'package:sparkd/main.dart';
import 'package:sparkd/pages/auth/login/login_response.dart';
import 'package:sparkd/pages/payment/payment_plan/payment_plan_controller.dart';
import 'package:sparkd/routes/app_pages.dart';

import '../../../../models/error_response.dart';

class OtpVerificationController extends GetxController {
  TextEditingController otpController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
  // final PaymentPlanController _paymentPlanController =
  //     getPaymentPlanController();
 String? selectedGender;
  String? selectedAgeRange;
  String? selectedPersonality;
  RxInt currentPage = 0.obs;
  String? gender;
  String? ageRange;
  String? personalityType;
   String? name;
  String? email;
  String? authprovider;
  void handleNavigation() {
    // _paymentPlanController.isUserSubscribedToProduct((p0) {
    //     Map chatmsg = {
    //     "name": "Otp Api done Payment api call"
    //   };
    //   Constants.socket!.emit("logEvent", chatmsg);
    //   if (p0 == true) {
    //     Get.offNamed(Routes.DASHBOARD);
    //   } else {
    //     Get.offNamed(Routes.PAYMENT_PLAN);
    //   }
    // });
  }

  @override
  void onInit() {
    if (Get.arguments != null) {
      selectedGender = Get.arguments[HttpUtil.gender];
      selectedAgeRange = Get.arguments[HttpUtil.age];
       selectedPersonality = Get.arguments[HttpUtil.personalityType];
      name = Get.arguments[HttpUtil.name];
      email = Get.arguments[HttpUtil.email];
      authprovider = Get.arguments[HttpUtil.authProvider];
    }
    super.onInit();
  }

  Future<void> onSignup() async {
     var json = {
      HttpUtil.name:name,
      HttpUtil.authProvider: authprovider,
      HttpUtil.email: email,
      HttpUtil.password: passwordController.text.trim(),
      HttpUtil.gender: selectedGender!,
      HttpUtil.age: selectedAgeRange,
      HttpUtil.personalityType:  selectedPersonality!,
      HttpUtil.profileImageUrl: "",
    };
    final data = await APIFunction().apiCall(
      apiName: Constants.signUp,
      withOutFormData: jsonEncode(json),
    );
    try {
      LoginResponse mainModel = LoginResponse.fromJson(data);
        Map chatmsg = {
        "name": "User data store Api"
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
      utils.showToast(message: errorModel.message!);
    }
  }
String genderValue(Genders gender) {
    switch (gender) {
      case Genders.Male:
        return "Male";
      case Genders.Female:
        return "Female";
      case Genders.Other:
        return "Other";
    }
  }

  String personalityTypeValue(Personality personalityType) {
    switch (personalityType) {
      case Personality.Seductive:
        return "Seductive";
      case Personality.Extrovert:
        return "Extrovert";
      case Personality.Introvert:
        return "Introvert";
      case Personality.Romantic:
        return "Romantic";
    }
  }

  Future<void> codeVerification() async {
    if (isOTPValidation()) {
      var json = {
        HttpUtil.email: email,
        HttpUtil.otp: otpController.text.trim(),
      };
      final data = await APIFunction().apiCall(
        apiName: Constants.verifyOTP,
        withOutFormData: jsonEncode(json),
      );
      try {
        LoginResponse mainModel = LoginResponse.fromJson(data);
        if (mainModel.success!) {
          await onSignup();
          // Get.offNamed(Routes.CREATE_PASSWORD, arguments: {
          //   HttpUtil.email: emailValue,
          //   HttpUtil.isForgetPin: isForgetPin,
          // });
        } else {
          utils.showToast(message: mainModel.message!);
        }
      } catch (e) {
        ErrorResponse errorModel = ErrorResponse.fromJson(data);
        utils.showToast(message: errorModel.message!);
      }
    }
  }

  bool isOTPValidation() {
    utils.hideKeyboard();
    if (utils.isValidationEmpty(otpController.text)) {
      utils.showToast(message: AppStrings.errorOTP);
      return false;
    } else if (otpController.text.length != 4) {
      utils.showToast(message: AppStrings.errorValidOTP);
      return false;
    }
    return true;
  }
}
