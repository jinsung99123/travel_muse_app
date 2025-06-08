import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plans.dart';
import 'package:travel_muse_app/providers/schedule_provider.dart';
import 'package:travel_muse_app/views/plan/place_search/place_search_page.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/day_schedule_section.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/schedule_app_bar.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key, required this.userId, required this.planId});
  final String userId;
  final String planId;

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  bool _isEditing = false;

  /// dayIndex -> 장소 리스트
  final Map<int, List<Map<String, String>>> daySchedules = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      //사용자 plan불러오기
      await ref
          .read(scheduleViewModelProvider.notifier)
          .fetchPlans(widget.userId);

      //planId 꺼내서 route 불러오기
      final routes = await ref
          .read(scheduleViewModelProvider.notifier)
          .fetchRoute(widget.planId); // planId 사용

      setState(() {
        daySchedules.clear();
        daySchedules.addAll(routes);
      });
    });
  }

  void _onReorder(int dayIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final movedItem = daySchedules[dayIndex]!.removeAt(oldIndex);
      daySchedules[dayIndex]!.insert(newIndex, movedItem);
    });
  }

  Future<void> _addPlace(int dayIndex, String planId) async {
    final selectedPlaces = await Navigator.push<List<Map<String, String>>>(
      context,
      MaterialPageRoute(builder: (context) => const PlaceSearchPage()),
    );

    if (selectedPlaces != null && selectedPlaces.isNotEmpty) {
      setState(() {
        daySchedules.putIfAbsent(dayIndex, () => []);
        daySchedules[dayIndex]!.addAll(selectedPlaces);
      });

      // 저장
      await ref
          .read(scheduleViewModelProvider.notifier)
          .saveDaySchedules(planId: planId, daySchedules: daySchedules);
    }
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(scheduleViewModelProvider);

    return Scaffold(
      appBar: ScheduleAppBar(
        isEditing: _isEditing,
        onToggleEdit: () async {
          setState(() {
            _isEditing = !_isEditing;
          });

          // 완료 버튼 눌렀을 때만 저장
          if (!_isEditing) {
            await ref
                .read(scheduleViewModelProvider.notifier)
                .saveDaySchedules(
                  planId: widget.planId,
                  daySchedules: daySchedules,
                );
          }
        },
      ),
      body: planState.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(child: Text('일정이 없습니다.'));
          }

          final plan = plans.first; // 첫 번째 계획만 사용
          final dayCount = plan.endDate.difference(plan.startDate).inDays + 1;

          return ListView.builder(
            itemCount: dayCount,
            itemBuilder: (context, dayIndex) {
              final currentDate = plan.startDate.add(Duration(days: dayIndex));
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
                onAddPlace: (dayIndex) => _addPlace(dayIndex, plan.planId),
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
