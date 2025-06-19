import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plan/planstate.dart';
import 'package:travel_muse_app/providers/plan/calendar_location_provider.dart';
import 'package:travel_muse_app/viewmodels/user/auth_view_model.dart';

class CalendarLocationViewModel extends StateNotifier<PlanState> {
  CalendarLocationViewModel(this.ref) : super(PlanState());

  final Ref ref;

  /// 시작 날짜를 설정
  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  /// 종료 날짜를 설정
  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  /// 여행 지역을 설정
  void setRegion(String region) {
    state = state.copyWith(region: region);
  }

  /// 외부에서 planId가 주어진 경우, 해당 plan 데이터를 Firestore에 저장
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

  /// 내부에서 planId를 생성하여 plan 데이터를 저장
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

  /// 시작일과 종료일을 함께 설정
  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  /// 유저의 가장 가까운 미래의 플랜을 로드
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
