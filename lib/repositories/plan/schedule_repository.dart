import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/plan/plans.dart';

class ScheduleRepository {
  ScheduleRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Firestore에서 여행 플랜 리스트를 조회합니다.
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

  /// 사용자가 저장한 플랜(plan)을 Firestore에서 조회합니다.
  Future<List<Plans>> fetchSavedPlans(String userId) async {
    try {
      final userDoc = await _firestore.collection('appUser').doc(userId).get();

      if (!userDoc.exists) return [];

      final List<String> planIdList = List<String>.from(
        userDoc.data()!['planId'],
      );

      if (planIdList.isEmpty) return [];

      final plansQuery =
          await _firestore
              .collection('plans')
              .where(FieldPath.documentId, whereIn: planIdList)
              .get();

      return plansQuery.docs
          .map((doc) => Plans.fromJson(doc.id, doc.data()))
          .toList();
    } catch (e) {
      log('fetchSavedPlans 에러: $e');
      return [];
    }
  }

  // appUser planId에 플랜 아이디 저장
  Future<void> addPlanIdToUser({
    required String userId,
    required String planId,
  }) async {
    final userDocRef = _firestore.collection('appUser').doc(userId);

    await userDocRef.update({
      'planId': FieldValue.arrayUnion([planId]),
    });
    log('planId 등록 시도');
  }

/// 특정 플랜(planId)에 대한 날짜별(dayIndex) 여행 일정을 Firestore에 저장합니다.
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

  /// 전체 AI 추천 일정 저장
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

  /// 특정 날짜 AI 추천 일정 수정
  Future<void> updateAiRoute({
    required String planId,
    required int dayIndex,
    required List<Map<String, String>> updatedPlaces,
  }) async {
    final dayRef = FirebaseFirestore.instance
        .collection('plans')
        .doc(planId)
        .collection('ai_route')
        .doc('day_$dayIndex');

    await dayRef.update({'places': updatedPlaces});
  }

  /// 특정 날짜 AI 추천 일정 삭제
  Future<void> deleteAiRoute({
    required String planId,
    required int dayIndex,
  }) async {
    final dayRef = FirebaseFirestore.instance
        .collection('plans')
        .doc(planId)
        .collection('ai_route')
        .doc('day_$dayIndex');

    await dayRef.delete();
  }

  /// AI 추천 일정(ai_route) 불러오기
  Future<Map<int, List<Map<String, String>>>> fetchAiRoute(
    String planId,
  ) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('plans')
            .doc(planId)
            .collection('ai_route')
            .get();

    final Map<int, List<Map<String, String>>> result = {};

    for (var doc in snapshot.docs) {
      final key = doc.id.replaceFirst('day_', '');
      final day = int.tryParse(key);
      if (day != null) {
        final List<dynamic> places = doc.data()['places'] ?? [];
        result[day] =
            places
                .map<Map<String, String>>((e) => Map<String, String>.from(e))
                .toList();
      }
    }

    return result;
  }

  /// Firestore에 저장된 특정 플랜(planId)의 날짜별 여행 일정을 불러옵니다.
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
