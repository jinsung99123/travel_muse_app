import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/core/widgets/long_bottom_button.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/models/plan/plans.dart';
import 'package:travel_muse_app/providers/plan/schedule/schedule_provider.dart';
import 'package:travel_muse_app/utills/date_utils.dart';
import 'package:travel_muse_app/views/my_page/plan_list_page.dart';
import 'package:travel_muse_app/views/plan/plan/place_search/place_search_page.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/ai_button.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/day_schedule_list.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/distance_sort_button.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/place_detail_bottom_sheet.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/schedule_header.dart';
import 'package:travel_muse_app/views/plan/plan/widgets/schedule_app_bar.dart';

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
  final Map<int, bool> _expandedMap = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final viewModel = ref.read(scheduleViewModelProvider.notifier);

    await viewModel.fetchPlans(widget.userId);
    await viewModel.fetchSavedPlans();
    final plans = ref.read(scheduleViewModelProvider).valueOrNull;

    selectedPlan = plans?.allPlans.firstWhere((p) => p.planId == widget.planId);

    final routes = await viewModel.fetchRoute(widget.planId);
    setState(() {
      daySchedules = routes;
    });
  }

  // 일정 편집 관련
  void _onReorder(int fromDay, int fromIndex, int toDay, int toIndex) {
    setState(() {
      final moved = daySchedules[fromDay]!.removeAt(fromIndex);
      daySchedules.putIfAbsent(toDay, () => []);

      final list = daySchedules[toDay]!;

      final safeIndex = toIndex.clamp(0, list.length);
      list.insert(safeIndex, moved);
    });

    ref
        .read(scheduleViewModelProvider.notifier)
        .saveDaySchedules(planId: widget.planId, daySchedules: daySchedules);
  }

  Future<void> _addPlace(int dayIndex) async {
    final selectedPlaces = await Navigator.push<List<Map<String, String>>>(
      context,
      MaterialPageRoute(
        builder:
            (_) => PlaceSearchPage(
              planId: widget.planId,
              region: selectedPlan?.region ?? '',
            ),
      ),
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

  Future<void> _toggleEdit() async {
    setState(() => _isEditing = !_isEditing);
    if (!_isEditing) {
      await ref
          .read(scheduleViewModelProvider.notifier)
          .saveDaySchedules(planId: widget.planId, daySchedules: daySchedules);
    }
  }

  void _insertPlace(int dayIndex, Map<String, String> place) {
    setState(() {
      daySchedules.putIfAbsent(dayIndex, () => []);
      daySchedules[dayIndex]!.insert(0, place);
    });

    ref
        .read(scheduleViewModelProvider.notifier)
        .saveDaySchedules(planId: widget.planId, daySchedules: daySchedules);
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(scheduleViewModelProvider);

    if (selectedPlan == null) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      appBar: ScheduleAppBar(planId: widget.planId, daySchedules: daySchedules),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            ScheduleHeader(isEditing: _isEditing, onToggleEdit: _toggleEdit),

            // Day 리스트
            Expanded(
              child: planState.when(
                data: (_) {
                  if (selectedPlan == null) {
                    return const Center(child: Text('선택된 일정이 없습니다.'));
                  }
                  return DayScheduleList(
                    selectedPlan: selectedPlan!,
                    daySchedules: daySchedules,
                    expandedMap: _expandedMap,
                    onToggleExpanded: (dayIndex) {
                      setState(() {
                        _expandedMap[dayIndex] =
                            !(_expandedMap[dayIndex] ?? true);
                      });
                    },
                    isEditing: _isEditing,
                    onReorder: _onReorder,
                    onAddPlace: _addPlace,
                    onRemovePlace: _removePlace,
                    onInsertPlace: _insertPlace,
                    onPlaceTap: (place) {
                      final converted = HomePlace(
                        id: place['id'] ?? '',
                        title: place['title'] ?? '',
                        subtitle: place['subtitle'] ?? '',
                        address: place['address'] ?? '',
                        thumbnail: place['image'] ?? '',
                        latLng: LatLng(
                          double.tryParse(place['lat'] ?? '') ?? 0.0,
                          double.tryParse(place['lng'] ?? '') ?? 0.0,
                        ),
                        category: place['category'] ?? '',
                      );

                      PlaceDetailBottomSheet.show(
                        context,
                        converted,
                        showSelectButton: false,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('에러 발생: $e')),
              ),
            ),
            LongBottomButton(
              onEditTap: () async {
                await ref
                    .read(scheduleViewModelProvider.notifier)
                    .saveDaySchedules(
                      planId: widget.planId,
                      daySchedules: daySchedules,
                    );
                await ref
                    .read(scheduleViewModelProvider.notifier)
                    .addPlanIdToAppUser(widget.planId);
                if (context.mounted){
                CustomToast.show(
                  context: context,
                  message: '일정이 저장되었습니다.',
                  duration: const Duration(seconds: 2),
                );
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PlanListPage()),
                );
                }
              },
              buttonText: '일정 저장하기',
              backgroundColor: AppColors.primary[300]!,
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60, right: 16, left: 16),
        child: Align(
          alignment: Alignment.bottomRight,
          child:
              _isEditing
                  ? DistanceSortButton(
                    daySchedules: daySchedules,
                    onResult: (sorted) {
                      setState(() {
                        daySchedules = sorted;
                      });
                    },
                  )
                  : AiButton(
                    planId: widget.planId,
                    days: calculateTripDays(
                      selectedPlan!.startDate,
                      selectedPlan!.endDate,
                    ),
                    region: selectedPlan!.region,
                    onResult: (parsed) async {
                      setState(() {
                        daySchedules = parsed;
                      });
                      await ref
                          .read(scheduleViewModelProvider.notifier)
                          .saveDaySchedules(
                            planId: widget.planId,
                            daySchedules: parsed,
                          );
                    },
                  ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
