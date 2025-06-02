import 'package:flutter/material.dart';

class OnboardingTab3 extends StatelessWidget {
  const OnboardingTab3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('반가워요, nickname 님!', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        Text('성향 테스트를 시작해 볼까요?', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
