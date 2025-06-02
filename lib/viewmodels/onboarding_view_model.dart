import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_1.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_2.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_3.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPageIndex = 0;

  final List<Widget> pages = const [
    OnboardingTab1(),
    OnboardingTab2(),
    OnboardingTab3(),
  ];

  void nextPage() {
    if (currentPageIndex < pages.length - 1) {
      currentPageIndex++;
      pageController.animateToPage(
        currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      notifyListeners();
    }
  }

  void previousPage() {
    if (currentPageIndex > 0) {
      currentPageIndex--;
      pageController.animateToPage(
        currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      notifyListeners();
    }
  }
}
