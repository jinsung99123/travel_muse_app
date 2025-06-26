import 'package:cloud_firestore/cloud_firestore.dart';

class PlanState {
  PlanState({
    this.planId,
    this.startDate,
    this.endDate,
    this.region,
    this.userId,
  });

  final String? planId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? region;
  final String? userId;

  PlanState copyWith({
    String? planId,
    DateTime? startDate,
    DateTime? endDate,
    String? region,
    String? userId,
  }) {
    return PlanState(
      planId: planId ?? this.planId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      region: region ?? this.region,
      userId: userId ?? this.userId,
    );
  }

  factory PlanState.fromMap(Map<String, dynamic> map) {
    return PlanState(
      planId: map['planId'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      region: map['region'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'planId': planId,
      'startDate': startDate,
      'endDate': endDate,
      'region': region,
      'userId': userId,
    };
  }
}
