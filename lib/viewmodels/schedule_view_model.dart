import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plans.dart';

class ScheduleViewModel extends StateNotifier<AsyncValue<List<Plans>>> {
  ScheduleViewModel() : super(const AsyncLoading()) {
    fetchPlans(); // 기본 호출
  }

  final _firestore = FirebaseFirestore.instance;

  // plans 불러오기 (userId 선택적으로 임시)
  Future<void> fetchPlans([String? userId]) async {
    try {
      Query query = _firestore.collection('plans');

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final snapshot = await query.get();

      final plans = snapshot.docs
    .map((doc) => Plans.fromJson(doc.id, doc.data() as Map<String, dynamic>))
    .toList();

      state = AsyncData(plans);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // daySchedules 저장
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

      batch.set(dayRef, {
        'places': places,
      });
    });

    await batch.commit();
    print('✅ daySchedules 저장 완료');
  }

  //route 불러오기
  Future<Map<int, List<Map<String, String>>>> fetchRoute(String planId) async {
  final snapshot = await _firestore
      .collection('plans')
      .doc(planId)
      .collection('route') // 여기 이름 바뀐거!!
      .get();

  final result = <int, List<Map<String, String>>>{};

  for (var doc in snapshot.docs) {
    final key = int.tryParse(doc.id.replaceFirst('day_', ''));
    if (key != null) {
      final data = doc.data();
      final places = (data['places'] as List)
          .map((e) => Map<String, String>.from(e))
          .toList();
      result[key] = places;
    }
  }

  return result;
}

}
