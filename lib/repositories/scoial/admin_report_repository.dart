import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/scoial/reported_comment.dart';
import 'package:travel_muse_app/models/scoial/reported_post.dart';

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
            await _firestore.collection('appUser').doc(userId).get();
        final nickname =
            userSnapshot.exists
                ? (userSnapshot.data()?['nickname'] ?? '알 수 없음')
                : '탈퇴한 사용자';

        // 신고 문서 조회
        final reports =
            await _firestore
                .collection('reports')
                .where('targetType', isEqualTo: 'post')
                .where('targetId', isEqualTo: postId)
                .get();

        final reasonCode =
            reports.docs.map((e) => e.data()['reasonCode'] as String).toList();
        final reasonText =
            reports.docs.map((e) => e.data()['reasonText'] as String?).toList();

        return ReportedPost.fromJson(
          data,
          postId,
          reasonCode: reasonCode,
          reasonText: reasonText,
          nickname: nickname,
        );
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

        // 각 댓글에 대한 신고 사유 가져오기
        final reportQuery =
            await _firestore
                .collection('reports')
                .where('targetType', isEqualTo: 'comment')
                .where('targetId', isEqualTo: commentId)
                .get();

        final reasonCode =
            reportQuery.docs
                .map((e) => e.data()['reasonCode'] as String)
                .toList();

        final reasonText =
            reportQuery.docs
                .map((e) => e.data()['reasonText'] as String?)
                .toList();

        final userSnapshot =
            await _firestore.collection('appUser').doc(userId).get();
        final nickname =
            userSnapshot.exists
                ? (userSnapshot.data()?['nickname'] ?? '알 수 없음')
                : '탈퇴한 사용자';

        return ReportedComment.fromJson(
          data,
          postId,
          commentId,
          reasonCode,
          reasonText,
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
