import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserRepository {
  final _firestore = FirebaseFirestore.instance;

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
}
