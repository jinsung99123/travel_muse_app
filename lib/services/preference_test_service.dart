import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';

class PreferenceTestService {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'preference_test';

  /// Firestore에 테스트 저장
  Future<String> saveTest(PreferenceTest test) async {
    final docRef = _firestore.collection(_collection).doc();
    final data = test.copyWith(testId: docRef.id).toMap();
    await docRef.set(data);
    return docRef.id;
  }

  /// Firestore에서 테스트 불러오기 (단건)
  Future<PreferenceTest> fetchTest(String testId) async {
    final doc = await _firestore.collection(_collection).doc(testId).get();
    return PreferenceTest.fromDoc(doc.id, doc.data()!);
  }

  Future<void> saveOrUpdateTest(PreferenceTest test) async {
    final docRef = _firestore.collection(_collection).doc(test.testId);
    await docRef.set(test.toMap()); // 이미 존재하면 덮어씀
  }

  Stream<PreferenceTest> watchTest(String testId) {
    return _firestore.collection(_collection).doc(testId).snapshots().map((
      doc,
    ) {
      final data = doc.data();
      if (data == null) throw Exception('문서가 존재하지 않음');
      return PreferenceTest.fromDoc(doc.id, data);
    });
  }
}
