import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarRepository {
  CalendarRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  Future<void> updatePlanDates({
    required String planId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final duration = endDate.difference(startDate).inDays + 1;

    await _firestore.collection('plans').doc(planId).update({
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'duration': duration,
    });
  }
}
