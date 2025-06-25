import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_muse_app/models/home/home_place.dart';

class ScrapRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

/// 현재 로그인한 사용자의 스크랩 목록에 장소 데이터를 저장
  Future<void> saveScrap(HomePlace place) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('appUser')
        .doc(uid)
        .collection('scrapped_places')
        .doc(place.id)
        .set(place.toMap());
  }

/// 현재 로그인한 사용자의 스크랩 목록에서 해당 장소 제거
  Future<void> deleteScrap(String placeId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('appUser')
        .doc(uid)
        .collection('scrapped_places')
        .doc(placeId)
        .delete();
  }


/// 현재 사용자가 특정 장소를 스크랩했는지 여부 반환
  Future<bool> isScrapped(String placeId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    final doc = await _firestore
        .collection('appUser')
        .doc(uid)
        .collection('scrapped_places')
        .doc(placeId)
        .get();

    return doc.exists;
  }
  /// 현재 로그인한 사용자가 스크랩한 모든 장소 목록을 반환
  Future<List<HomePlace>> fetchScrappedPlaces() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return [];

  final snapshot = await FirebaseFirestore.instance
      .collection('appUser')
      .doc(uid)
      .collection('scrapped_places')
      .get();

  return snapshot.docs
      .map((doc) => HomePlace.fromMap(doc.data()))
      .toList();
}

}
