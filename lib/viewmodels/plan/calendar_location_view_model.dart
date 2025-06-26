import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plan/planstate.dart';
import 'package:travel_muse_app/providers/plan/calendar_location_provider.dart';
import 'package:travel_muse_app/providers/user/auth_view_model_provider.dart';

class CalendarLocationViewModel extends StateNotifier<PlanState> {
  CalendarLocationViewModel(this.ref) : super(PlanState());

  final Ref ref;

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void setRegion(String region) {
    state = state.copyWith(region: region);
  }

  Future<void> savePlan(String planId) async {
    final start = state.startDate;
    final end = state.endDate;
    final region = state.region;
    final userId = ref.read(authViewModelProvider).user?.uid;

    if (start == null || end == null || region == null || userId == null) {
      throw Exception('날짜, 지역 또는 사용자 정보가 누락되었습니다.');
    }

    final repo = ref.read(calendarLocationRepositoryProvider);
    await repo.savePlan(
      planId: planId,
      startDate: start,
      endDate: end,
      region: region,
      userId: userId,
    );

    state = state.copyWith(planId: planId);
  }

  Future<String> createAndSavePlan() async {
    final start = state.startDate;
    final end = state.endDate;
    final region = state.region;
    final userId = ref.read(authViewModelProvider).user?.uid;

    if (start == null || end == null || region == null || userId == null) {
      throw Exception('날짜, 지역 또는 사용자 정보가 누락되었습니다.');
    }

    final repo = ref.read(calendarLocationRepositoryProvider);
    final planId = await repo.createAndSavePlan(
      startDate: start,
      endDate: end,
      region: region,
      userId: userId,
    );

    state = state.copyWith(planId: planId);

    return planId;
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  Future<void> loadNearestUpcomingPlan() async {
    final userId = ref.read(authViewModelProvider).user?.uid;
    if (userId == null) {
      debugPrint('[loadNearestUpcomingPlan] 유저 ID 없음');
      return;
    }

    final repo = ref.read(calendarLocationRepositoryProvider);
    final plan = await repo.fetchNearestUpcomingPlan(userId);

    if (plan != null) {
      debugPrint(
        '[loadNearestUpcomingPlan] 가장 가까운 여행 로드됨: ${plan.startDate}, ${plan.planId}',
      );
      state = plan;
    } else {
      debugPrint('[loadNearestUpcomingPlan] 불러올 여행 없음');
    }
  }

  /// 날짜와 지역을 인자로 받아 상태를 세팅하고 저장까지 처리하는 통합 함수
  Future<String> savePlanWithDates(
    String region,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final userId = ref.read(authViewModelProvider).user?.uid;
    if (userId == null) {
      throw Exception('사용자 정보가 누락되었습니다.');
    }

    // 상태 업데이트
    state = state.copyWith(
      region: region,
      startDate: startDate,
      endDate: endDate,
    );

    final repo = ref.read(calendarLocationRepositoryProvider);

    if (state.planId != null) {
      // 기존 planId가 있으면 업데이트
      await repo.savePlan(
        planId: state.planId!,
        startDate: startDate,
        endDate: endDate,
        region: region,
        userId: userId,
      );
      return state.planId!;
    } else {
      // 새로 생성 및 저장
      final newPlanId = await repo.createAndSavePlan(
        startDate: startDate,
        endDate: endDate,
        region: region,
        userId: userId,
      );
      state = state.copyWith(planId: newPlanId);
      return newPlanId;
    }
  }
}
