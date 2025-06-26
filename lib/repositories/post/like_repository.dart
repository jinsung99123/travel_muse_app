import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LikeRepository {
  Future<void> addLike({required String postId, required String userId});

  Future<void> removeLike({required String postId, required String userId});

  Future<bool> isPostLikedByUser({
    required String postId,
    required String userId,
  });

  Future<List<String>> getLikedPostIdsByUser({required String userId});
}

class LikeRepositoryImpl implements LikeRepository {
  LikeRepositoryImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<void> addLike({required String postId, required String userId}) async {
    final docId = '${postId}_$userId';
    await _firestore.collection('likes').doc(docId).set({
      'postId': postId,
      'userId': userId,
      'likedAt': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('posts').doc(postId).update({
      'likeCount': FieldValue.increment(1),
    });
  }

  @override
  Future<void> removeLike({
    required String postId,
    required String userId,
  }) async {
    final docId = '${postId}_$userId';
    await _firestore.collection('likes').doc(docId).delete();
    await _firestore.collection('posts').doc(postId).update({
      'likeCount': FieldValue.increment(-1),
    });
  }

  @override
  Future<bool> isPostLikedByUser({
    required String postId,
    required String userId,
  }) async {
    final docId = '${postId}_$userId';
    final doc = await _firestore.collection('likes').doc(docId).get();
    return doc.exists;
  }

  @override
  Future<List<String>> getLikedPostIdsByUser({required String userId}) async {
    final snapshot =
        await _firestore
            .collection('likes')
            .where('userId', isEqualTo: userId)
            .get();
    return snapshot.docs.map((doc) => doc['postId'] as String).toList();
  }
}
