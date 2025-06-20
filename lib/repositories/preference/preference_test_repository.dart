import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_muse_app/models/preference/preference_test_model.dart';

class PreferenceTestRepository {
  final currentUser = FirebaseAuth.instance.currentUser;

  final _firestore = FirebaseFirestore.instance;
  final _collection = 'preference_test';

  /// Firestore에 테스트 저장
  Future<String> saveTest(PreferenceTest test) async {
    final docRef = _firestore.collection(_collection).doc();
    final data = test.copyWith(testId: docRef.id).toMap();
    await docRef.set(data);
    return docRef.id;
  }

  /// 테스트 ID에 따라 새로 저장하거나 업데이트
  Future<PreferenceTest> saveOrUpdateTest(PreferenceTest test) async {
    if (test.testId.isEmpty) {
      final newId = await saveTest(test);
      return test.copyWith(testId: newId);
    } else {
      await updateTest(test);
      return test;
    }
  }

  /// 기존 테스트 업데이트
  Future<void> updateTest(PreferenceTest test) async {
    await _firestore.collection(_collection).doc(test.testId).set(test.toMap());
  }

  /// appUser testId에 테스트 아이디 저장
  Future<void> addTestIdToUser({required String testId}) async {
    if (currentUser == null) return;
    final userDocRef = _firestore.collection('appUser').doc(currentUser!.uid);

    await userDocRef.update({
      'testId': FieldValue.arrayUnion([testId]),
    });
    log('테스트아이디 업데이트 : $testId');
  }

  /// 테스트 ID로 테스트 불러오기
  Future<PreferenceTest> loadTest(String testId) async {
    return await fetchTest(testId);
  }

  /// Firestore에서 테스트 불러오기 (단건)
  Future<PreferenceTest> fetchTest(String testId) async {
    final doc = await _firestore.collection(_collection).doc(testId).get();
    return PreferenceTest.fromDoc(doc.id, doc.data()!);
  }

  /// 테스트 실시간 감시 스트림
  Stream<PreferenceTest> watchTest(String testId) {
    return _firestore.collection(_collection).doc(testId).snapshots().map((
      doc,
    ) {
      final data = doc.data();
      if (data == null) throw Exception('문서가 존재하지 않음');
      return PreferenceTest.fromDoc(doc.id, data);
    });
  }

  /// Firestore에서 userId로 테스트 모두 불러오기
  Future<List<PreferenceTest>> fetchTestsByUserId(String userId) async {
    final querySnapshot =
        await _firestore
            .collection(_collection)
            .where('userId', isEqualTo: userId)
            .get();

    return querySnapshot.docs
        .map((doc) => PreferenceTest.fromDoc(doc.id, doc.data()))
        .toList();
  }

  ///테스트Id로 삭제
  Future<void> deleteTest(String testId) async {
    await _firestore.collection(_collection).doc(testId).delete();
  }
}
