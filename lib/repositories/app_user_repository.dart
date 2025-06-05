import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserRepository {
  final _firestore = FirebaseFirestore.instance;

  // 첫 로그인 시 데이터베이스에 유저 정보 생성
  Future<void> createAppUser(String uid) async {
    final docRef = _firestore.collection('appUser').doc(uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({
        'uid': uid,
        'nickname': null,
        'profileImage': null,
        'testId': [],
        'planId': [],
      });
    }
  }

  // 유저 닉네임 업데이트
  Future<void> updateNickname(String uid, String nickname) async {
    await _firestore.collection('appUser').doc(uid).update({
      'nickname': nickname,
    });
  }

  // 유저 프로필이미지 업데이트
}
