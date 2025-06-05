import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/widgets/preference_card.dart';

class PreferenceListPage extends StatelessWidget {
  const PreferenceListPage({super.key});

  static const List<Map<String, String>> travelStyles = [
    {'title': '여행 성향1', 'description': '산, 바다, 숲에서 여유를 즐기는 여행'},
    {'title': '여행 성향2', 'description': '도심 속 카페, 전시, 쇼핑 탐방'},
    {'title': '여행 성향3', 'description': '하이킹, 스노우보드, 서핑 등 활동적인 여행'},
    {'title': '여행 성향4', 'description': '지역 맛집 탐방과 음식 중심의 여행'},
    {'title': '여행 성향5', 'description': '역사와 문화를 배우는 여행'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('여행 성향 목록'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: travelStyles.length,
        itemBuilder: (context, index) {
          final style = travelStyles[index];
          return PreferenceCard(
            title: style['title'] ?? '',
            description: style['description'] ?? '',
          );
        },
      ),
    );
  }
}
