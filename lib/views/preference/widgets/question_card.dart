import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.question});
  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              color: Color(0xFF26272A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.5,
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '이 질문을 바탕으로 여행 성향을 분석해드릴게요!',
            style: TextStyle(
              color: Color(0xFF7C878C),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }
}
