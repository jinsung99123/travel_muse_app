import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plan/plans.dart';
import 'package:travel_muse_app/repositories/plan/calendar_location_repository.dart';
import 'package:travel_muse_app/repositories/plan/schedule_repository.dart';
import 'package:travel_muse_app/utills/date_utils.dart';

class ScheduleState {
  const ScheduleState({
    this.allPlans = const <Plans>[],
    this.savedPlans = const <Plans>[],
  });

  final List<Plans> allPlans;
  final List<Plans> savedPlans;

  ScheduleState copyWith({List<Plans>? allPlans, List<Plans>? savedPlans}) =>
      ScheduleState(
        allPlans: allPlans ?? this.allPlans,
        savedPlans: savedPlans ?? this.savedPlans,
      );
}

class ScheduleViewModel extends StateNotifier<AsyncValue<ScheduleState>> {
  ScheduleViewModel(this._repository) : super(const AsyncData(ScheduleState()));

  final ScheduleRepository _repository;
  List<Plans> _allPlans = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  final calendarLocationRepo = CalendarLocationRepository();

  /// 선택된 plan 캐싱
  Plans? selectedPlan;

  /// 사용자 계획 불러오기
  Future<void> fetchPlans([String? userId]) async {
    try {
      final plans = await _repository.fetchPlans(userId);
      _allPlans = plans;
      state = AsyncData(state.value!.copyWith(allPlans: plans));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// 수동 저장한 사용자 계획 불러오기
  Future<void> fetchSavedPlans() async {
    if (currentUser == null) return;
    try {
      final plans = await _repository.fetchSavedPlans(currentUser!.uid);
      state = AsyncData(state.value!.copyWith(savedPlans: plans));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// 현재 로그인한 사용자의 appUser 문서에 planId를 추가합니다.
  Future<void> addPlanIdToAppUser(String planId) async {
    if (currentUser == null) return;
    try {
      await _repository.addPlanIdToUser(
        userId: currentUser!.uid,
        planId: planId,
      );
    } catch (e) {
      log('planId appUser에 추가 실패 : $e');
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

  /// 주어진 [planId]에 해당하는 여행 계획(Plan)을 반환합니다.
  Plans? getPlanById(String planId) {
    try {
      return _allPlans.firstWhere((p) => p.planId == planId);
    } catch (e) {
      return null;
    }
  }

  /// 주어진 [planId]에 해당하는 일정(Route)이 존재하는지 확인합니다.
  Future<bool> hasRoute(String planId) async {
    final snap = await _repository.fetchRoute(planId);
    return snap.isNotEmpty;
  }

  /// 일정삭제
  Future<void> deletePlanById(String planId) async {
    if (currentUser == null) return;
    try {
      // DB에서 삭제
      await _repository.deletePlanById(planId);

      // appUser 문서에서 planId 제거
      await _repository.removePlanIdFromUser(
        userId: currentUser!.uid,
        planId: planId,
      );

      // 상태 동기화
      _allPlans.removeWhere((p) => p.planId == planId);
      final updatedSavedPlans =
          state.value!.savedPlans.where((p) => p.planId != planId).toList();

      state = AsyncData(
        state.value!.copyWith(
          allPlans: _allPlans,
          savedPlans: updatedSavedPlans,
        ),
      );
    } catch (e, st) {
      log('일정 삭제 실패: $e');
      state = AsyncError(e, st);
    }
  }

  /// 여행일수를 반환합니다.
  Future<int> getTripDays(String planId) async {
    try {
      final plan = getPlanById(planId);
      if (plan == null) return 1;

      final tripDays = calculateTripDays(plan.startDate, plan.endDate);
      return tripDays;
    } catch (e) {
      log('여행일수 계산 실패: $e');
      return 1; // 기본값
    }
  }
}
