import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/plan/calendar_location_provider.dart';
import 'package:travel_muse_app/viewmodels/user/auth_view_model.dart';

class PlanState {
  PlanState({this.planId, this.startDate, this.endDate, this.region});
  final String? planId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? region;

  PlanState copyWith({
    String? planId,
    DateTime? startDate,
    DateTime? endDate,
    String? region,
  }) {
    return PlanState(
      planId: planId ?? this.planId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      region: region ?? this.region,
    );
  }
}

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

  /// 외부에서 planId를 넘겨주는 경우
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

    // 상태에 planId 업데이트 (필요 시)
    state = state.copyWith(planId: planId);
  }

  /// 내부에서 자동 planId 생성 후 저장
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

    // 생성된 planId를 상태에 저장
    state = state.copyWith(planId: planId);

    return planId;
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  Future<void> loadNearestUpcomingPlan() async {
    final userId = ref.read(authViewModelProvider).user?.uid;
    if (userId == null) return;

    final repo = ref.read(calendarLocationRepositoryProvider);
    final plan = await repo.fetchNearestUpcomingPlan(userId);

    if (plan != null) {
      state = plan;
    }
  }
}
