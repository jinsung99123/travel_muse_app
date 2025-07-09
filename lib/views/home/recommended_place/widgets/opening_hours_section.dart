import 'package:flutter/material.dart';

class OpeningHoursSection extends StatefulWidget {
  const OpeningHoursSection({super.key, required this.weekdayHours});
  final List<dynamic> weekdayHours;

  @override
  State<OpeningHoursSection> createState() => _OpeningHoursSectionState();
}

class _OpeningHoursSectionState extends State<OpeningHoursSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hours = widget.weekdayHours;

    final todayIndex = DateTime.now().weekday % 7; 
    final koreanWeekdays = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
    final todayLabel = koreanWeekdays[todayIndex];

    final todayHour = hours.firstWhere(
      (text) => text.startsWith(todayLabel),
      orElse: () => hours.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목 + 접기/더보기 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(Icons.calendar_today, '영업 시간'),
            GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Row(
                children: [
                  Text(
                    isExpanded ? '접기' : '더보기',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 펼친 상태면 전체 표시 / 접힌 상태면 오늘만 표시
        if (isExpanded)
          ...hours.map<Widget>(
            (text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(text),
            ),
          )
        else
          Text(
            todayHour,
            style: const TextStyle(color: Colors.black),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
