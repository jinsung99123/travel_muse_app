import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/widgets/schedule_card.dart';
import 'package:travel_muse_app/views/plan/schedule/schedule_page.dart';

class PlanListPage extends StatelessWidget {
  const PlanListPage({super.key});

  static const List<Map<String, String>> schedules = [
    {'title': '제주도 여행', 'date': '2025-07-01'},
    {'title': '강원도 캠핑', 'date': '2025-08-15'},
    {'title': '서울 투어', 'date': '2025-06-20'},
    {'title': '부산 바다여행', 'date': '2025-09-05'},
    {'title': '전주 한옥마을', 'date': '2025-10-12'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('여행 일정 목록'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SchedulePage()),
              );
            },
            child: ScheduleCard(
              title: schedule['title'] ?? '',
              date: schedule['date'] ?? '',
              imageUrl: 'https://picsum.photos/800/400?random=$index',
            ),
          );
        },
      ),
    );
  }
}
