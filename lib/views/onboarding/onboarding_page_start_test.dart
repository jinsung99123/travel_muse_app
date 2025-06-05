import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/onboarding/widgets/next_button.dart';

class OnboardingPageStartTest extends StatelessWidget {
  const OnboardingPageStartTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('테스트 시작')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('반가워요, Nickname 님!', style: TextStyle(fontSize: 32)),
            Text('여행 성향 테스트를 시작해 볼까요?', style: TextStyle(fontSize: 20)),
            Spacer(),
            NextButton(
              text: '테스트 시작',
              onPressed: () {
                // 다음 페이지로
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
