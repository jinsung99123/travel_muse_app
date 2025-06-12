import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/calendar_locaion_provider.dart';

class PlanState {
  PlanState({this.startDate, this.endDate, this.region});
  final DateTime? startDate;
  final DateTime? endDate;
  final String? region;

  PlanState copyWith({DateTime? startDate, DateTime? endDate, String? region}) {
    return PlanState(
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

    if (start == null || end == null || region == null) {
      throw Exception("날짜 또는 지역 정보가 누락되었습니다.");
    }

    final repo = ref.read(calendarLocationRepositoryProvider);
    await repo.savePlan(
      planId: planId,
      startDate: start,
      endDate: end,
      region: region,
    );
  }

  /// 내부에서 자동 planId 생성 후 저장
  Future<String> createAndSavePlan() async {
    final start = state.startDate;
    final end = state.endDate;
    final region = state.region;

    if (start == null || end == null || region == null) {
      throw Exception("날짜 또는 지역 정보가 누락되었습니다.");
    }

    final repo = ref.read(calendarLocationRepositoryProvider);
    final planId = await repo.createAndSavePlan(
      startDate: start,
      endDate: end,
      region: region,
    );

    return planId;
  }
}
