import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/views/onboarding/widgets/next_button.dart';

class OnboardingPageStartTest extends ConsumerWidget {
  const OnboardingPageStartTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ai 기반 맞춤 추천을 위해\nnickname님의 여행 성향을 알려주세요',
                        style: AppTextStyles.onboardingTitle,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '6가지 질문에 대답해주신 대로\n여행성향 결과를 파악해서 추천해드릴게요!',
                        style: AppTextStyles.onboardingSubTitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Spacer(),
                ClipRRect(
                  child: Image.asset('assets/images/onboarding_image1.png'),
                ),

                SizedBox(height: 100),
                NextButton(
                  text: '시작하기',
                  onPressed: () {
                    // 다음 페이지로
                  },
                ),
                SizedBox(height: 34),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
