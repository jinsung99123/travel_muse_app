import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/post/post_model.dart';

abstract class LikeRepository {
  Future<void> addLike({required String postId, required String userId});

  Future<void> removeLike({required String postId, required String userId});
  Future<List<Post>> fetchLikedPosts(String userId);

  Future<bool> isPostLikedByUser({
    required String postId,
    required String userId,
  });

  Future<List<String>> getLikedPostIdsByUser({required String userId});
}

class LikeRepositoryImpl implements LikeRepository {
  LikeRepositoryImpl(this._firestore);
  final FirebaseFirestore _firestore;

  /// 게시물에 좋아요 추가 및 게시물의 좋아요 수 증가
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

  /// 게시물의 좋아요 취소 및 좋아요 수 감소
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

  /// 게시물이 사용자가 좋아요한 상태인지 여부 확인
  @override
  Future<bool> isPostLikedByUser({
    required String postId,
    required String userId,
  }) async {
    final docId = '${postId}_$userId';
    final doc = await _firestore.collection('likes').doc(docId).get();
    return doc.exists;
  }

  /// 사용자가 좋아요한 게시물의 ID 목록 가져오기
  @override
  Future<List<String>> getLikedPostIdsByUser({required String userId}) async {
    final snapshot =
        await _firestore
            .collection('likes')
            .where('userId', isEqualTo: userId)
            .get();
    return snapshot.docs.map((doc) => doc['postId'] as String).toList();
  }

  /// 사용자가 좋아요한 게시물(Post) 객체 목록을 불러오기
  @override
  Future<List<Post>> fetchLikedPosts(String userId) async {
    final likeSnapshot =
        await _firestore
            .collection('likes')
            .where('userId', isEqualTo: userId)
            .get();

    final postIds =
        likeSnapshot.docs.map((doc) => doc['postId'] as String).toList();

    final posts = <Post>[];

    for (final postId in postIds) {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        posts.add(Post.fromMap(doc.data()!));
      }
    }

    return posts;
  }
}
