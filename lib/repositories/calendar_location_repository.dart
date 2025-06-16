import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/viewmodels/calendar_location_view_model.dart';

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

  Future<PlanState?> fetchNearestUpcomingPlan(String userId) async {
    final now = DateTime.now();

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('plans')
            .where('userId', isEqualTo: userId)
            .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
            .orderBy('startDate')
            .limit(1)
            .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final doc = querySnapshot.docs.first;
    final data = doc.data();

    return PlanState(
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      region: data['region'] as String,
    );
  }
}
