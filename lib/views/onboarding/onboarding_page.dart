import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/onboarding_view_model.dart';
import 'package:travel_muse_app/views/onboarding/widgets/onboarding_tab_section.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(onboardingProvider.notifier);
    final state = ref.watch(onboardingProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: viewModel.previousPage,
            child: const SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        // 온보딩 탭 영역
        body: OnboardingTabSection(viewModel: viewModel, state: state),
      ),
    );
  }
}
