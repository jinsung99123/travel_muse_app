import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_muse_app/models/app_user_model.dart';

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
        'birthDate': null,
        'gender': null,
      });
    }
  }

  // 데이터베이스에서 유저 정보 get
  Future<AppUser?> fetchLatestAppUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('appUser').doc(uid).get();
    if (doc.data() == null) {
      return null;
      // TODO: 뷰모델에서 유저 정보 없는 경우 처리
      // '세션이 만료되었습니다. 다시 로그인해 주세요.' - 강제 로그아웃, 재로그인 유도
    }
    return AppUser.fromJson(doc.data()!);
  }

  // 유저 닉네임 중복확인
  Future<bool> isNicknameDuplicate(String nickname) async {
    final query =
        await _firestore
            .collection('appUser')
            .where('nickname', isEqualTo: nickname)
            .limit(1)
            .get();

    return query.docs.isNotEmpty;
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

  // 이미지 스토리지에 업로드, url return
  Future<String> uploadProfileImage({
    required String uid,
    required File file,
  }) async {
    final fileName = '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    // 이미지 업로드 & get url
    final ref = _storage.ref().child('userProfiles/$uid/$fileName');
    await ref.putFile(file);
    final fileUrl = await ref.getDownloadURL();

    return fileUrl;
  }

  // 유저 프로필이미지 업데이트
  Future<void> updateProfileImage({
    required String uid,
    required String fileUrl,
  }) async {
    // 이미지 url 데이터베이스 업데이트
    await _firestore.collection('appUser').doc(uid).update({
      'profileImage': fileUrl,
    });
  }

  // 유저 생년월일 업데이트
  Future<void> updateBirthDate({
    required String uid,
    required String birthDate,
  }) async {
    await _firestore.collection('appUser').doc(uid).update({
      'birthDate': birthDate,
    });
  }

  // 유저 성별 업데이트
  Future<void> updateGender({
    required String uid,
    required String gender,
  }) async {
    await _firestore.collection('appUser').doc(uid).update({'gender': gender});
  }
}
