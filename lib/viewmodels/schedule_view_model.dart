import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plans.dart';
import 'package:travel_muse_app/repositories/schedule_repository.dart';

class ScheduleViewModel extends StateNotifier<AsyncValue<List<Plans>>> {
  ScheduleViewModel(this._repository) : super(const AsyncLoading());

  final ScheduleRepository _repository;
  List<Plans> _allPlans = [];

  /// 선택된 plan 캐싱
  Plans? selectedPlan;

  /// 사용자 계획 불러오기
  Future<void> fetchPlans([String? userId]) async {
    try {
      final plans = await _repository.fetchPlans(userId);
      _allPlans = plans;
      state = AsyncData(plans);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// 현재 plan 설정
  void setSelectedPlan(String planId) {
    selectedPlan = _allPlans.firstWhere(
      (p) => p.planId == planId,
      orElse: () => _allPlans.first,
    );
  }

  /// daySchedules 수동 입력 저장용
  Future<void> saveDaySchedules({
    required String planId,
    required Map<int, List<Map<String, String>>> daySchedules,
  }) async {
    await _repository.saveDaySchedules(
      planId: planId,
      daySchedules: daySchedules,
    );
  }

  /// AI 추천 일정 저장용
  Future<void> saveAiSchedules({
    required String planId,
    required Map<int, List<Map<String, String>>> daySchedules,
  }) async {
    await _repository.saveAiRoute(planId: planId, aiSchedules: daySchedules);
  }

  /// 특정 날짜 AI 추천 일정 수정
  Future<void> updateAiSchedule({
    required String planId,
    required int dayIndex,
    required List<Map<String, String>> updatedPlaces,
  }) async {
    await _repository.updateAiRoute(
      planId: planId,
      dayIndex: dayIndex,
      updatedPlaces: updatedPlaces,
    );
  }

  /// 특정 날짜 AI 추천 일정 삭제
  Future<void> deleteAiSchedule({
    required String planId,
    required int dayIndex,
  }) async {
    await _repository.deleteAiRoute(planId: planId, dayIndex: dayIndex);
  }

  /// AI 추천 일정(ai_route) 불러오기
  Future<Map<int, List<Map<String, String>>>> fetchAiSchedules(
    String planId,
  ) async {
    return await _repository.fetchAiRoute(planId);
  }

  /// route 불러오기
  Future<Map<int, List<Map<String, String>>>> fetchRoute(String planId) async {
    return await _repository.fetchRoute(planId);
  }

  Plans? getPlanById(String planId) {
    try {
      return _allPlans.firstWhere((p) => p.planId == planId);
    } catch (e) {
      return null;
    }
  }
}
