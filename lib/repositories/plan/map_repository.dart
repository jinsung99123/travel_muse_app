import 'package:cloud_firestore/cloud_firestore.dart';

class MapRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getPlan(String planId) async {
    final doc = await _firestore.collection('plans').doc(planId).get();
    return doc.data();
  }

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
