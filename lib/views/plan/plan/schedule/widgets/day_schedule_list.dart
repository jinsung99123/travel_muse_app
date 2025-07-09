import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/plan/plans.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/day_schedule_section.dart';

class DayScheduleList extends StatelessWidget {
  const DayScheduleList({
    super.key,
    required this.selectedPlan,
    required this.daySchedules,
    required this.isEditing,
    required this.onReorder,
    required this.onAddPlace,
    required this.onRemovePlace,
    this.onPlaceTap,
  });

  final Plans selectedPlan;
  final Map<int, List<Map<String, String>>> daySchedules;
  final bool isEditing;
  final void Function(int dayIndex, int oldIndex, int newIndex) onReorder;
  final Future<void> Function(int dayIndex) onAddPlace;
  final void Function(int dayIndex, int placeIndex) onRemovePlace;
  final void Function(Map<String, String> place)? onPlaceTap;

  String _getWeekday(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dayCount =
        selectedPlan.endDate.difference(selectedPlan.startDate).inDays + 1;

    return ListView.separated(
      itemCount: dayCount,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, dayIndex) {
        final currentDate =
            selectedPlan.startDate.add(Duration(days: dayIndex));
        final dayLabel =
            '${currentDate.month}.${currentDate.day} (${_getWeekday(currentDate.weekday)})';

        daySchedules.putIfAbsent(dayIndex, () => []);

        return DayScheduleSection(
          key: ValueKey('day-$dayIndex'),
          dayIndex: dayIndex,
          dayLabel: dayLabel,
          schedules: daySchedules[dayIndex]!,
          isEditing: isEditing,
          onReorder: onReorder,
          onAddPlace: onAddPlace,
          onRemovePlace: onRemovePlace,
          onPlaceTap: onPlaceTap,
        );
      },
    );
  }
}