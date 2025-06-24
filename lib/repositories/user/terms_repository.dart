import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/user/terms_model.dart';

class TermsRepository {
  final _firestore = FirebaseFirestore.instance;

  /// 약관 업로드or업데이트 (개발 전용)
  Future<void> updateOrUploadTerms(Terms terms) async {
    final docRef = _firestore.collection('terms').doc(terms.id);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update(terms.toJson());
      log('✅ 약관 "${terms.id}" 업데이트 완료');
    } else {
      await docRef.set(terms.toJson());
      log('✅ 약관 "${terms.id}" 생성 완료');
    }
  }

  // 모든 약관 가져와서 order순으로 나열
  Future<List<Terms>> fetchAllTermsOrdered() async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('terms')
            .orderBy('order')
            .get();

    return querySnapshot.docs.map((doc) {
      return Terms.fromJson(doc.id, doc.data());
    }).toList();
  }
}

/// 예시 약관(추후 삭제)
final ageRequired = Terms(
  id: 'age_required',
  title: '만 14세 이상입니다.',
  content: '',
  isRequired: true,
  version: '1.0',
  createdAt: DateTime.now(),
  order: 1,
  url: '',
);

final serviceRequired = Terms(
  id: 'service_required',
  title: '서비스 이용 약관',
  content: '서비스 이용 약관 내용입니다.',
  isRequired: true,
  version: '1.0',
  createdAt: DateTime.now(),
  order: 2,
  url: 'https://www.notion.so/1abc9d67bce980809f96d10b19049af2',
);

final privacyRequired = Terms(
  id: 'privacy_required',
  title: '개인정보 처리 방침',
  content: '개인정보 처리 방침 내용입니다.',
  isRequired: true,
  version: '1.0',
  createdAt: DateTime.now(),
  order: 3,
  url: 'https://www.notion.so/21cc9d67bce980d58f34ec20ee46d139',
);

final marketingOptional = Terms(
  id: 'marketing_optional',
  title: '마케팅 수신 동의',
  content: '마케팅 수신 동의 내용입니다.',
  isRequired: false,
  version: '1.0',
  createdAt: DateTime.now(),
  order: 4,
  url: 'https://www.notion.so/21cc9d67bce980ab9579ebf380ad5d2c',
);

final communityPolicy = Terms(
  id: 'community_policy',
  title: '커뮤니티 운영정책',
  content: '커뮤니티 운영정책 내용입니다.',
  isRequired: true,
  version: '1.0',
  createdAt: DateTime.now(),
  order: 5,
  url: 'https://www.notion.so/21cc9d67bce980b1a257c3a7dcf39cc2',
);

final locationRequired = Terms(
  id: 'location_required',
  title: '위치정보 이용동의',
  content: '위치정보 이용동의 내용입니다.',
  isRequired: true,
  version: '1.0',
  createdAt: DateTime.now(),
  order: 6,
  url: 'https://www.notion.so/21cc9d67bce9802e92f5fbaceffe6190',
);


Future<void> uploadAllTerms() async {
  final repo = TermsRepository();
  await repo.updateOrUploadTerms(ageRequired);
  await repo.updateOrUploadTerms(serviceRequired);
  await repo.updateOrUploadTerms(privacyRequired);
  await repo.updateOrUploadTerms(marketingOptional);
  await repo.updateOrUploadTerms(communityPolicy);
  await repo.updateOrUploadTerms(locationRequired);
}
