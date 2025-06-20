import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

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
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.5,
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
