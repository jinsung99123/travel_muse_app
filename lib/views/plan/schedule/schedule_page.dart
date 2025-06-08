import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plans.dart';
import 'package:travel_muse_app/providers/schedule_provider.dart';
import 'package:travel_muse_app/views/plan/place_search/place_search_page.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/day_schedule_section.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/schedule_app_bar.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  bool _isEditing = false;

  /// dayIndex -> 장소 리스트
  final Map<int, List<Map<String, String>>> daySchedules = {};

  void _onReorder(int dayIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final movedItem = daySchedules[dayIndex]!.removeAt(oldIndex);
      daySchedules[dayIndex]!.insert(newIndex, movedItem);
    });
  }

  void _addPlace(int dayIndex) async {
    final selectedPlace = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const PlaceSearchPage()),
    );

    if (selectedPlace != null) {
      setState(() {
        daySchedules.putIfAbsent(dayIndex, () => []);
        daySchedules[dayIndex]!.add(selectedPlace);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(scheduleViewModelProvider);

    return Scaffold(
      appBar: ScheduleAppBar(
        isEditing: _isEditing,
        onToggleEdit: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
      ),
      body: planState.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(child: Text('일정이 없습니다.'));
          }

          final plan = plans.first; // 우선 하나만 사용
          final dayCount = plan.endDate.difference(plan.startDate).inDays + 1;

          return ListView.builder(
            itemCount: dayCount,
            itemBuilder: (context, dayIndex) {
              final currentDate =
                  plan.startDate.add(Duration(days: dayIndex));
              final dayLabel =
                  '${currentDate.month}.${currentDate.day} (${_getWeekday(currentDate.weekday)})';

              daySchedules.putIfAbsent(dayIndex, () => []);

              return DayScheduleSection(
                key: ValueKey('day-$dayIndex'),
                dayIndex: dayIndex,
                dayLabel: dayLabel,
                schedules: daySchedules[dayIndex]!,
                isEditing: _isEditing,
                onReorder: _onReorder,
                onAddPlace: _addPlace,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('에러 발생: $e')),
      ),
    );
  }

  String _getWeekday(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[weekday - 1];
  }
}
