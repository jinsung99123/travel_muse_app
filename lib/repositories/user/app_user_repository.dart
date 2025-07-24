import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_muse_app/models/user/app_user_model.dart';
import 'package:travel_muse_app/models/user/user_agreement_model.dart';

class AppUserRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// 첫 로그인 시 데이터베이스에 유저 정보 생성
  Future<void> createAppUser(String uid) async {
    final docRef = _firestore.collection('appUser').doc(uid);
    final snapshot = await docRef.get();

    final user = FirebaseAuth.instance.currentUser;
    final provider = user?.providerData.first;
    if (provider == null) {
      return;
    }

    if (!snapshot.exists) {
      await docRef.set({
        'uid': uid,
        'loginProvider': provider.providerId,
        'loginEmail': provider.email,
        'nickname': null,
        'profileImage': null,
        'testId': [],
        'planId': [],
        'birthDate': null,
        'gender': null,
      });
    }
  }

  // 유저 파일 있는지 확인
  Future<bool> doesUserDocumentExist(String uid) async {
    final doc = await _firestore.collection('appUser').doc(uid).get();
    return doc.exists;
  }

  /// 데이터베이스에서 uid로 해당 유저 정보 get
  Future<AppUser?> fetchLatestAppUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('appUser').doc(uid).get();
    if (doc.data() == null) {
      return null;
    }
    return AppUser.fromJson(doc.data()!);
  }

  /// 프로필 이미지 스토리지에 업로드, url return
  Future<String> uploadProfileImage({
    required String uid,
    required File file,
  }) async {
    final fileName = '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    /// 이미지 업로드 & get url
    final ref = _storage.ref().child('userProfiles/$uid/$fileName');
    await ref.putFile(file);
    final fileUrl = await ref.getDownloadURL();

    return fileUrl;
  }

  /// appUser 프로필이미지 url 가져오기
  Future<String?> fetchProfileImageUrl({required String uid}) async {
    final doc =
        await FirebaseFirestore.instance.collection('appUser').doc(uid).get();

    final url = doc.data()?['profileImage'];

    if (url is String && url.isNotEmpty) {
      return url;
    }
    return null;
  }

  /// 유저 프로필이미지 업데이트
  Future<void> updateProfileImage({
    required String uid,
    required String fileUrl,
  }) async {
    await _firestore.collection('appUser').doc(uid).update({
      'profileImage': fileUrl,
    });
  }

  /// 유저 닉네임 중복확인
  Future<bool> isNicknameDuplicate(String nickname) async {
    final query =
        await _firestore
            .collection('appUser')
            .where('nickname', isEqualTo: nickname)
            .limit(1)
            .get();

    return query.docs.isNotEmpty;
  }

  /// 유저 닉네임 업데이트
  Future<void> updateNickname({
    required String uid,
    required String nickname,
  }) async {
    await _firestore.collection('appUser').doc(uid).update({
      'nickname': nickname,
    });
  }

  /// 유저 약관 동의(UserAgreement) 업데이트
  Future<void> uploadUserAgreements(
    String uid,
    List<UserAgreement> agreementList,
  ) async {
    final batch = _firestore.batch();

    final collectionRef = _firestore
        .collection('appUser')
        .doc(uid)
        .collection('userAgreements');

    for (final agreement in agreementList) {
      final docRef = collectionRef.doc(agreement.termId);

      batch.set(docRef, agreement.toJson(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// 회원 탈퇴
  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef = _firestore.collection('appUser').doc(user.uid);
    final userAgreementsRef = userDocRef.collection('userAgreements');

    // 서브컬렉션 'userAgreements' 문서 모두 삭제
    final agreementsSnapshot = await userAgreementsRef.get();
    for (final doc in agreementsSnapshot.docs) {
      await doc.reference.delete();
    }

    // preference_test 문서 중 userId == user.uid 인 문서 모두 삭제
    final preferenceSnapshot =
        await _firestore
            .collection('preference_test')
            .where('userId', isEqualTo: user.uid)
            .get();
    for (final doc in preferenceSnapshot.docs) {
      await doc.reference.delete();
    }

    // plans 문서 중 userId == user.uid 인 문서 모두 삭제
    final plansSnapshot =
        await _firestore
            .collection('plans')
            .where('userId', isEqualTo: user.uid)
            .get();
    for (final doc in plansSnapshot.docs) {
      await doc.reference.delete();
    }

    await userDocRef.delete();
  }
}
