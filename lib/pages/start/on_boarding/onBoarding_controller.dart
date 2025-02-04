import 'package:sparkd/api_repository/api_class.dart';
import 'package:sparkd/core/constants/imports.dart';

import '../../../routes/app_pages.dart';

class OnBoardingController extends GetxController {
  Genders? selectedGender;
  String? selectedAgeRange;
  Personality? selectedPersonality;
  RxInt currentPage = 0.obs;
  final PageController pageController = PageController();

  void onGenderSelection(Genders gender) {
    selectedGender = gender;
    update();
    _nextPage();
  }

  void onAgeSelection(String age) {
    selectedAgeRange = age;

    update();
    _nextPage();
  }

  void onPersonalitySelection(Personality personality) {
    selectedPersonality = personality;
    update();
  }

  void _nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
  
  Genders? gender;
  String? ageRange;
  Personality? personalityType;
  createAccount() {
    Get.offNamed(Routes.SIGN_UP, arguments: {
      HttpUtil.gender: genderValue(gender!),
      HttpUtil.age: ageRange,
      HttpUtil.personalityType: personalityTypeValue(personalityType!),
    });
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

  void onFinish() {
    Get.offNamed(Routes.SIGN_UP, arguments: {
      HttpUtil.gender: selectedGender,
      HttpUtil.age: selectedAgeRange,
      HttpUtil.personalityType: selectedPersonality,
    });
  }

  void onLogin() {
    Get.offNamed(Routes.LOGIN);
  }
}
