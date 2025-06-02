import 'package:flutter/material.dart';
import 'package:travel_muse_app/viewmodels/onboarding_view_model.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_1.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_2.dart';
import 'package:travel_muse_app/views/onboarding/tabs/onboarding_tab_3.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingPage> {
  final viewmodel = OnboardingViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            viewmodel.previousPage();
          },
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: PageView(
              controller: viewmodel.pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [OnboardingTab1(), OnboardingTab2(), OnboardingTab3()],
            ),
          ),
          nextButton(),
          SizedBox(height: 30),
        ],
      ),
    );
  }
  // ui 종료

  // 버튼 위젯
  Widget nextButton() {
    final int lastPageIndex = viewmodel.pages.length - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed:
              viewmodel.currentPageIndex != lastPageIndex
                  ? viewmodel.nextPage
                  : () {
                    // 성향 검사 시작
                  },

          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff025ADF)),
          child: Text(
            viewmodel.currentPageIndex != lastPageIndex ? '다음' : '성향 테스트 시작하기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
