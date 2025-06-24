import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/scoial/reported_post.dart';
import 'package:travel_muse_app/models/scoial/reproted_comment.dart';

class AdminReportRepository {
  AdminReportRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<ReportedPost>> fetchReportedPosts() async {
    final snapshot = await _firestore
        .collection('posts')
        .where('isReposted', isEqualTo: true)
        .where('isDeleted', isEqualTo: false) // 🔥 중요!
        .get(const GetOptions(source: Source.server)); // 🔥 서버 강제 fetch

    return Future.wait(
      snapshot.docs.map((doc) async {
        final data = doc.data();
        final postId = doc.id;
        final userId = data['userId'];
        

        print('[DEBUG] postId: $postId');
        final userSnapshot =
            await _firestore.collection('users').doc(userId).get();
        final nickname = userSnapshot.data()?['nickname'] ?? '';

        return ReportedPost.fromJson(data, postId, nickname: nickname);
      }),
    );
  }

  Future<List<ReportedComment>> fetchReportedComments() async {
    final snapshot = await _firestore
        .collectionGroup('comments')
        .where('isReposted', isEqualTo: true)
        .get(const GetOptions(source: Source.server));

    return Future.wait(
      snapshot.docs.map((doc) async {
        final data = doc.data();
        final postId = doc.reference.parent.parent!.id;
        final commentId = doc.id;
        final userId = data['userId'];

        final userSnapshot =
            await _firestore.collection('users').doc(userId).get();
        final nickname = userSnapshot.data()?['nickname'] ?? '';

        return ReportedComment.fromJson(
          data,
          postId,
          commentId,
          nickname: nickname,
        );
      }),
    );
  }

  Future<void> deletePost(String postId) async {
    print('[DEBUG] 삭제 요청 postId: $postId');
    await _firestore.collection('posts').doc(postId).update({
      'isDeleted': true,
    });
  }

  Future<void> deleteComment(String postId, String commentId) async {
    print('[DEBUG] 삭제 요청 postId: $postId, commentId: $commentId');
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e, st) {
      print('[ERROR] 댓글 삭제 실패: $e');
      print('[ERROR] StackTrace: $st');
      rethrow;
    }
  }

  Future<void> clearReport(String type, String docId, {String? postId}) async {
    try {
      final ref =
          (type == 'post')
              ? _firestore.collection('posts').doc(docId)
              : _firestore
                  .collection('posts')
                  .doc(postId!)
                  .collection('comments')
                  .doc(docId);

      await ref.update({'isReposted': false, 'reportCount': 0});
    } catch (e, st) {
      print('[ERROR] clearReport 실패 ($type - $docId): $e');
      rethrow;
    }
  }
}
