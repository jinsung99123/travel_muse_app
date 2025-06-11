import 'package:cloud_firestore/cloud_firestore.dart';

/// 시작일(start)과 종료일(end)을 받아 여행일수를 계산한다.
/// - Timestamp 또는 DateTime 모두 지원
/// - 동일 날짜도 1일로 계산
int calculateTripDays(dynamic start, dynamic end) {
  DateTime? startDate;
  DateTime? endDate;

  if (start is Timestamp) {
    startDate = start.toDate();
  } else if (start is DateTime) {
    startDate = start;
  }

  if (end is Timestamp) {
    endDate = end.toDate();
  } else if (end is DateTime) {
    endDate = end;
  }

  if (startDate == null || endDate == null) return 1;

  return endDate.difference(startDate).inDays + 1;
}
