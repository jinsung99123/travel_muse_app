import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_1.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_2.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_3.dart';

class OnboardingState {
  final int currentPageIndex;

  const OnboardingState({this.currentPageIndex = 0});
}

class OnboardingViewModel extends Notifier<OnboardingState> {
  late final PageController pageController;

  final List<Widget> pages = const [
    OnboardingTab1(),
    OnboardingTab2(),
    OnboardingTab3(),
  ];
  @override
  OnboardingState build() {
    pageController = PageController();
    return const OnboardingState();
  }

  void nextPage() {
    if (state.currentPageIndex < pages.length - 1) {
      final next = state.currentPageIndex + 1;
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      state = OnboardingState(currentPageIndex: next);
    }
  }

  void previousPage() {
    if (state.currentPageIndex > 0) {
      final prev = state.currentPageIndex - 1;
      pageController.animateToPage(
        prev,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      state = OnboardingState(currentPageIndex: prev);
    }
  }

  void setPageIndex(int index) {
    state = OnboardingState(currentPageIndex: index);
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
      () => OnboardingViewModel(),
    );
