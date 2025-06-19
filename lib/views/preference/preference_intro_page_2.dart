import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class PreferenceIntroPage2 extends StatelessWidget {
  const PreferenceIntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ai 기반 맞춤 추천을 위해\n사용자님의 여행 성향을 알려주세요',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '6가지 질문에 대답해주신 대로\n여행성향 결과를 파악해서 추천해드릴게요!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey[400],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/test_start.png',
                  width: 333,
                  height: 333,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: CupertinoButton(
                  color: const Color(0xFF48CDFD),
                  borderRadius: BorderRadius.circular(10),
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const PreferenceTestPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
