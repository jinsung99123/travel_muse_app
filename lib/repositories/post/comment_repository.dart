import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';

class CommentRepository {
  CommentRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference getCommentsRef(String postId) =>
      _firestore.collection('posts').doc(postId).collection('comments');

  Future<void> addComment(String postId, Comment comment) async {
    await getCommentsRef(postId).doc(comment.commentId).set(comment.toMap());
  }

  Stream<List<Comment>> getComments(String postId) {
    return getCommentsRef(postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Comment.fromDoc(doc)).toList(),
        );
  }

  Future<void> toggleLike(
    String postId,
    String commentId,
    String userId,
  ) async {
    final ref = getCommentsRef(postId).doc(commentId);
    final snapshot = await ref.get();
    final data = snapshot.data() as Map<String, dynamic>;
    final likedUserIds = List<String>.from(data['likedUserIds'] ?? []);

    if (likedUserIds.contains(userId)) {
      likedUserIds.remove(userId);
    } else {
      likedUserIds.add(userId);
    }

    await ref.update({'likedUserIds': likedUserIds});
  }

  Future<void> reportComment(String postId, String commentId) async {
    final ref = getCommentsRef(postId).doc(commentId);
    await _firestore.runTransaction((txn) async {
      final snapshot = await txn.get(ref);
      final data = snapshot.data() as Map<String, dynamic>;
      final count = (data['reportCount'] ?? 0) + 1;
      txn.update(ref, {'reportCount': count, 'isReported': count >= 3});
    });
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await getCommentsRef(postId).doc(commentId).delete();
  }

  Future<Map<String, String>> fetchUserInfo(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance
            .collection('appUser')
            .doc(userId)
            .get();
    final data = userDoc.data();
    return {
      'nickname': data?['nickname'] ?? '알 수 없음',
      'profileImage': data?['profileImage'] ?? '',
    };
  }

  Stream<List<Comment>> getReplies(String postId, String parentId) {
    return getCommentsRef(postId)
        .where('parentId', isEqualTo: parentId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Comment.fromDoc(doc)).toList(),
        );
  }
}
