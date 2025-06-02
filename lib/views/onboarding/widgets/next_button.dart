import 'package:flutter/material.dart';
import 'package:travel_muse_app/viewmodels/onboarding_view_model.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.state, required this.viewModel});

  final OnboardingState state;
  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            state.currentPageIndex != viewModel.pages.length - 1
                ? viewModel.nextPage
                : () {
                  // TODO: 성향 테스트 시작
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff025ADF),
        ),
        child: Text(
          state.currentPageIndex != viewModel.pages.length - 1
              ? '다음'
              : '성향 테스트 시작하기',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
