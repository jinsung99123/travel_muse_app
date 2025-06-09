import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class PreferenceIntroPage2 extends StatelessWidget {
  const PreferenceIntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ai 기반 맞춤 추천을 위해\n사용자님의 여행 성향을 알려주세요',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF26272A),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '6가지 질문에 대답해주신 대로\n여행성향 결과를 파악해서 추천해드릴게요!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7C878C),
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
                  width: 250,
                  height: 250,
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
                      color: Colors.white,
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
