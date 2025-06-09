import 'package:flutter/material.dart';

class IntroHeader extends StatelessWidget {
  const IntroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '사용자님의 여행 성향을 \n알려주세요',
            style: TextStyle(
              color: Color(0xFF26272A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '맞춤 여행 코스 추천을 위해 \n사용자님의 여행 성향 정보를 알려주세요',
            style: TextStyle(
              color: Color(0xFF7C878C),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
