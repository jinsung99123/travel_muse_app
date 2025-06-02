import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_image.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_nickname.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_start_test.dart';

class OnboardingState {
  const OnboardingState({this.currentPageIndex = 0});
  final int currentPageIndex;
}

class OnboardingViewModel extends Notifier<OnboardingState> {
  late final PageController pageController;

  final List<Widget> pages = const [
    OnboardingTabNickname(),
    OnboardingTabImage(),
    OnboardingTabStartTest(),
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
