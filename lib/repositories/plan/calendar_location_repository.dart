import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/plan/planstate.dart';

class CalendarLocationRepository {
  CalendarLocationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// planId에 해당하는 플랜 정보를 Firestore에 저장 또는 업데이트
  Future<void> savePlan({
    required String planId,
    required DateTime startDate,
    required DateTime? endDate, // 수정: nullable 허용
    required String region,
    required String userId,
  }) async {
    final actualEndDate = endDate ?? startDate; // 하루짜리 처리
    final duration = actualEndDate.difference(startDate).inDays + 1;

    await _firestore.collection('plans').doc(planId).set({
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(actualEndDate),
      'duration': duration,
      'region': region,
      'userId': userId,
    }, SetOptions(merge: true));
  }

  /// 새 planId를 생성하고 플랜 데이터를 Firestore에 저장
  Future<String> createAndSavePlan({
    required DateTime startDate,
    required DateTime? endDate, // 수정: nullable 허용
    required String region,
    required String userId,
  }) async {
    final actualEndDate = endDate ?? startDate; // 하루짜리 처리
    final duration = actualEndDate.difference(startDate).inDays + 1;

    final docRef = _firestore.collection('plans').doc();
    final planId = docRef.id;

    await docRef.set({
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(actualEndDate),
      'duration': duration,
      'region': region,
      'userId': userId,
    });

    return planId;
  }

  Future<PlanState?> fetchNearestUpcomingPlan(String userId) async {
    final now = DateTime.now();

    final querySnapshot =
        await _firestore
            .collection('plans')
            .where('userId', isEqualTo: userId)
            .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
            .orderBy('startDate')
            .limit(1)
            .get();

    if (querySnapshot.docs.isEmpty) return null;

    return PlanState.fromDoc(querySnapshot.docs.first);
  }

  /// userId의 사용자 문서에 planId를 추가
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
