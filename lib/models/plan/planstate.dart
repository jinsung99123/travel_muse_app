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
