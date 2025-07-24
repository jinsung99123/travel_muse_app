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
      log('약관 "${terms.id}" 업데이트 완료');
    } else {
      await docRef.set(terms.toJson());
      log('약관 "${terms.id}" 생성 완료');
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
