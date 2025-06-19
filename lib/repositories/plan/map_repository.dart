import 'package:cloud_firestore/cloud_firestore.dart';

/// 여행 플랜 및 경로 데이터를 Firestore에서 불러오는 저장소 클래스
class MapRepository {
  final _firestore = FirebaseFirestore.instance;

  /// 특정 여행 플랜(planId)의 메타 정보를 불러옵니다.
  Future<Map<String, dynamic>?> getPlan(String planId) async {
    final doc = await _firestore.collection('plans').doc(planId).get();
    return doc.data();
  }

   /// 여행 플랜의 일차별 경로(route) 데이터를 불러옵니다.
  Future<Map<String, List<Map<String, String>>>> getRouteByDay(String planId) async {
    final snapshot = await _firestore
        .collection('plans')
        .doc(planId)
        .collection('route')
        .get();

    Map<String, List<Map<String, String>>> result = {};
    for (var doc in snapshot.docs) {
      final dayKey = doc.id;
      final placeList = (doc.data()['places'] as List)
          .map((e) => Map<String, String>.from(e))
          .toList();
      result[dayKey] = placeList;
    }

    return result;
  }
}
