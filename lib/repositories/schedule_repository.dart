import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/plans.dart';

class ScheduleRepository {
  ScheduleRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<Plans>> fetchPlans([String? userId]) async {
    Query query = _firestore.collection('plans');
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) => Plans.fromJson(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveDaySchedules({
    required String planId,
    required Map<int, List<Map<String, String>>> daySchedules,
  }) async {
    final batch = _firestore.batch();

    daySchedules.forEach((dayIndex, places) {
      final dayRef = _firestore
          .collection('plans')
          .doc(planId)
          .collection('route')
          .doc('day_$dayIndex');

      batch.set(dayRef, {'places': places});
    });

    await batch.commit();
  }

  Future<void> saveAiRoute({
    required String planId,
    required Map<int, List<Map<String, String>>> aiSchedules,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    aiSchedules.forEach((dayIndex, places) {
      final dayRef = FirebaseFirestore.instance
          .collection('plans')
          .doc(planId)
          .collection('ai_route')
          .doc('day_$dayIndex');

      batch.set(dayRef, {'places': places});
    });

    await batch.commit();
  }

  Future<Map<int, List<Map<String, String>>>> fetchRoute(String planId) async {
    final snapshot =
        await _firestore
            .collection('plans')
            .doc(planId)
            .collection('route')
            .get();

    final result = <int, List<Map<String, String>>>{};

    for (var doc in snapshot.docs) {
      final key = int.tryParse(doc.id.replaceFirst('day_', ''));
      if (key != null) {
        final data = doc.data();
        final places =
            (data['places'] as List)
                .map((e) => Map<String, String>.from(e))
                .toList();
        result[key] = places;
      }
    }

    return result;
  }
}
