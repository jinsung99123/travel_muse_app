import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppUserRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

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
  Future<void> updateNickname({
    required String uid,
    required String nickname,
  }) async {
    await _firestore.collection('appUser').doc(uid).update({
      'nickname': nickname,
    });
  }

  // 유저 프로필이미지 업데이트
  Future<void> uploadProfileImage({
    required String uid,
    required File file,
  }) async {
    final fileName = '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    // 이미지 업로드 & get url
    final ref = _storage.ref().child('userProfiles/$uid/$fileName');
    await ref.putFile(file);
    final fileUrl = await ref.getDownloadURL();

    // 이미지 url 데이터베이스 업데이트
    await _firestore.collection('appUser').doc(uid).update({
      'profileImage': fileUrl,
    });
  }
}
