import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarLocationRepository {
  CalendarLocationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> savePlan({
    required String planId,
    required DateTime startDate,
    required DateTime endDate,
    required String region,
    required String userId,
  }) async {
    final duration = endDate.difference(startDate).inDays + 1;

    await _firestore.collection('plans').doc(planId).set({
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'duration': duration,
      'region': region,
      'userId': userId,
    }, SetOptions(merge: true));
  }

  Future<String> createAndSavePlan({
    required DateTime startDate,
    required DateTime endDate,
    required String region,
    required String userId,
  }) async {
    final duration = endDate.difference(startDate).inDays + 1;

    final docRef = _firestore.collection('plans').doc();
    final planId = docRef.id;

    await docRef.set({
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'duration': duration,
      'region': region,
      'userId': userId,
    });

    return planId;
  }

  Future<void> addPlanIdToUser({
    required String userId,
    required String planId,
  }) async {
    final userDocRef = _firestore.collection('appUser').doc(userId);

    await userDocRef.update({
      'planId': FieldValue.arrayUnion([planId]),
    });
  }
}
