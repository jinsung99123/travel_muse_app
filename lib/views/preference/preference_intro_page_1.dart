import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/widgets/intro_header.dart';
import 'package:travel_muse_app/views/preference/widgets/start_button.dart';
import 'package:travel_muse_app/views/preference/widgets/survey_preview_item.dart';

class PreferenceIntroPage1 extends StatelessWidget {
  const PreferenceIntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 80, 16, 120),
              children: const [
                IntroHeader(),
                SizedBox(height: 24),
                SurveyPreviewItem(number: '1', title: '여행 계획 수립 성향 파악'),
                SurveyPreviewItem(number: '2', title: '교통수단 선호도 파악'),
                SurveyPreviewItem(number: '3', title: '동반자 및 독립성 선호도 파악'),
                SurveyPreviewItem(number: '4', title: '활동 유형 및 테마 선호도 파악'),
                SurveyPreviewItem(number: '5', title: '선호 여행 스타일 파악'),
                SurveyPreviewItem(number: '6', title: '선호 여행 속도 파악'),
              ],
            ),
          ),
          const Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: StartButton(),
          ),
        ],
      ),
    );
  }
}
