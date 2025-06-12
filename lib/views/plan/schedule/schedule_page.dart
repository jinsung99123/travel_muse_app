import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/plans.dart';
import 'package:travel_muse_app/providers/schedule_provider.dart';
import 'package:travel_muse_app/utills/date_utils.dart';
import 'package:travel_muse_app/views/plan/place_search/place_search_page.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/ai_button.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/day_schedule_section.dart';
import 'package:travel_muse_app/views/plan/widgets/schedule_app_bar.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/schedule_bottom_button.dart';

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
      MaterialPageRoute(builder: (_) =>  PlaceSearchPage(planId:widget.planId,)),
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

  void _removePlace(int dayIndex, int placeIndex) {
    setState(() {
      daySchedules[dayIndex]?.removeAt(placeIndex);
    });

    ref
        .read(scheduleViewModelProvider.notifier)
        .saveDaySchedules(planId: widget.planId, daySchedules: daySchedules);
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(scheduleViewModelProvider);

    return Scaffold(
      appBar: ScheduleAppBar(planId: widget.planId),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    '여행 일정을 등록해주세요',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(32, 27),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () async {
                      setState(() => _isEditing = !_isEditing);
                      if (!_isEditing) {
                        await ref
                            .read(scheduleViewModelProvider.notifier)
                            .saveDaySchedules(
                              planId: widget.planId,
                              daySchedules: daySchedules,
                            );
                      }
                    },
                    child: Text(
                      _isEditing ? '완료' : '편집',
                      style: TextStyle(
                        color: AppColors.primary[500],
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: planState.when(
                data: (plans) {
                  if (selectedPlan == null) {
                    return const Center(child: Text('선택된 일정이 없습니다.'));
                  }

                  final dayCount =
                      selectedPlan!.endDate
                          .difference(selectedPlan!.startDate)
                          .inDays +
                      1;

                  return ListView.separated(
                    itemCount: dayCount,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
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
                        onRemovePlace: _removePlace,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('에러 발생: $e')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          selectedPlan == null
              ? null
              : AiButton(
                planId: widget.planId,
                days: calculateTripDays(
                  selectedPlan!.startDate,
                  selectedPlan!.endDate,
                ),
                region: selectedPlan!.region,
                onResult: (parsed) {
                  setState(() {
                    daySchedules = parsed;
                  });
                  ref
                      .read(scheduleViewModelProvider.notifier)
                      .saveAiSchedules(
                        planId: widget.planId,
                        daySchedules: parsed,
                      );
                },
              ),
      bottomNavigationBar: ScheduleBottomButtons(),
    );
  }

  String _getWeekday(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[weekday - 1];
  }
}

