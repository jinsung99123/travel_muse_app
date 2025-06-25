import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/scoial/reported_post.dart';
import 'package:travel_muse_app/models/scoial/reported_comment.dart';

/// 관리자용 신고 콘텐츠 관리 리포지토리
class AdminReportRepository {
  AdminReportRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// 신고된 게시글 리스트를 불러옵니다.
  /// 사용자 정보가 없는 경우 "탈퇴한 사용자"로 처리합니다.
  Future<List<ReportedPost>> fetchReportedPosts() async {
    final snapshot = await _firestore
        .collection('posts')
        .where('isReposted', isEqualTo: true)
        .where('isDeleted', isEqualTo: false)
        .get(const GetOptions(source: Source.server));

    return Future.wait(
      snapshot.docs.map((doc) async {
        final data = doc.data();
        final postId = doc.id;
        final userId = data['userId'];

        final userSnapshot =
            await _firestore.collection('users').doc(userId).get();
        final nickname =
            userSnapshot.exists
                ? (userSnapshot.data()?['nickname'] ?? '알 수 없음')
                : '탈퇴한 사용자';

        return ReportedPost.fromJson(data, postId, nickname: nickname);
      }),
    );
  }

  /// 신고된 댓글 리스트를 불러옵니다.
  /// 사용자 정보가 없는 경우 "탈퇴한 사용자"로 처리합니다.
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
        final nickname =
            userSnapshot.exists
                ? (userSnapshot.data()?['nickname'] ?? '알 수 없음')
                : '탈퇴한 사용자';

        return ReportedComment.fromJson(
          data,
          postId,
          commentId,
          nickname: nickname,
        );
      }),
    );
  }

  /// 게시글을 삭제 처리합니다.
  /// 실제 삭제가 아닌 isDeleted: true로 마킹하여 숨깁니다.
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).update({
      'isDeleted': true,
    });
  }

  /// 댓글을 실제 삭제합니다.
  Future<void> deleteComment(String postId, String commentId) async {
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

  /// 신고 상태를 해제합니다.
  /// isReposted: false, reportCount: 0으로 초기화
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
