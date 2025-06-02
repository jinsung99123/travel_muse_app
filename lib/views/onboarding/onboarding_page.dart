import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/onboarding_view_model.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(onboardingProvider.notifier);
    final state = ref.watch(onboardingProvider);

    return Scaffold(
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
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: viewModel.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: viewModel.setPageIndex,
              children: viewModel.pages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: nextButton(state, viewModel),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
  // ui 종료

  // 위젯
  ElevatedButton nextButton(
    OnboardingState state,
    OnboardingViewModel viewModel,
  ) {
    return ElevatedButton(
      onPressed:
          state.currentPageIndex != viewModel.pages.length - 1
              ? viewModel.nextPage
              : () {
                // TODO: 성향 테스트 시작
              },
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff025ADF)),
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
    );
  }
}
