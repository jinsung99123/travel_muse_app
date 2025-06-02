import 'package:flutter/material.dart';
import 'package:travel_muse_app/viewmodels/onboarding_view_model.dart';
import 'package:travel_muse_app/views/onboarding/widgets/next_button.dart';

class OnboardingTabSection extends StatelessWidget {
  const OnboardingTabSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  final OnboardingViewModel viewModel;
  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: viewModel.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: viewModel.setPageIndex,
              children: viewModel.pages,
            ),
          ),
          NextButton(state: state, viewModel: viewModel),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
