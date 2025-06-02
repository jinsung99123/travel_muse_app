import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/place_search/place_search_page.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/day_schedule_section.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/schedule_app_bar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  //추후 실제 데이터 적용예정
  final List<String> days = ['6.27/금', '6.28/토', '6.29/일'];
  bool _isEditing = false;

  //추후 실제 데이터 적용예정
  List<List<Map<String, String>>> daySchedules = [
    [
      {'title': '동문 새벽 시장', 'subtitle': '제주 쇼핑 명소', 'image': ''},
      {'title': '함덕 해수욕장', 'subtitle': '구좌 해변', 'image': ''},
    ],
    [],
    [],
  ];

  //viewmodel 분리예정
  void _onReorder(int dayIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final movedItem = daySchedules[dayIndex].removeAt(oldIndex);
      daySchedules[dayIndex].insert(newIndex, movedItem);
    });
  }

  void _addPlace(int dayIndex) async {
    final selectedPlace = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const PlaceSearchPage()),
    );

    if (selectedPlace != null) {
      setState(() {
        daySchedules[dayIndex].add(selectedPlace);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScheduleAppBar(
        isEditing: _isEditing,
        onToggleEdit: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, dayIndex) {
          return DayScheduleSection(
            key: ValueKey('day-$dayIndex'),
            dayIndex: dayIndex,
            dayLabel: days[dayIndex],
            schedules: daySchedules[dayIndex],
            isEditing: _isEditing,
            onReorder: _onReorder,
            onAddPlace: _addPlace,
          );
        },
      ),
    );
  }
}
