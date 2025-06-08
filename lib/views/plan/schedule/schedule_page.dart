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
  Map<int, List<Map<String, String>>> daySchedules = {};
  Plans? selectedPlan;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final viewModel = ref.read(scheduleViewModelProvider.notifier);

    await viewModel.fetchPlans(widget.userId);
    final plans = ref.read(scheduleViewModelProvider).valueOrNull;
    selectedPlan = plans?.firstWhere((p) => p.planId == widget.planId);

    final routes = await viewModel.fetchRoute(widget.planId);
    setState(() {
      daySchedules = routes;
    });
  }

  void _onReorder(int dayIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final movedItem = daySchedules[dayIndex]!.removeAt(oldIndex);
      daySchedules[dayIndex]!.insert(newIndex, movedItem);
    });
  }

  Future<void> _addPlace(int dayIndex) async {
    final selectedPlaces = await Navigator.push<List<Map<String, String>>>(
      context,
      MaterialPageRoute(builder: (_) => const PlaceSearchPage()),
    );

    if (selectedPlaces != null && selectedPlaces.isNotEmpty) {
      setState(() {
        daySchedules.putIfAbsent(dayIndex, () => []);
        daySchedules[dayIndex]!.addAll(selectedPlaces);
      });

      await ref
          .read(scheduleViewModelProvider.notifier)
          .saveDaySchedules(planId: widget.planId, daySchedules: daySchedules);
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
          if (selectedPlan == null) {
            return const Center(child: Text('선택된 일정이 없습니다.'));
          }

          final dayCount =
              selectedPlan!.endDate.difference(selectedPlan!.startDate).inDays +
              1;

          return ListView.builder(
            itemCount: dayCount,
            itemBuilder: (context, dayIndex) {
              final currentDate = selectedPlan!.startDate.add(
                Duration(days: dayIndex),
              );
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
