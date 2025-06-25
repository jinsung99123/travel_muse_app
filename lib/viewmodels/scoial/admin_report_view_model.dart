import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/scoial/admin_report_repository.dart';

class AdminReportViewModel extends StateNotifier<AsyncValue<List<Object>>> {
  AdminReportViewModel(this._repo) : super(const AsyncValue.loading()) {
    fetchReports();
  }

  final AdminReportRepository _repo;

  /// Firestore에서 신고된 게시글과 댓글 목록을 모두 불러옵니다.
  /// 게시글, 댓글을 한 리스트로 통합하여 상태에 저장합니다.
  Future<void> fetchReports() async {
    try {
      state = const AsyncValue.loading();
      final posts = await _repo.fetchReportedPosts();
      final comments = await _repo.fetchReportedComments();
      state = AsyncValue.data([...posts, ...comments]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 게시글을 삭제 처리합니다.
  Future<void> deletePost(String postId) async {
    try {
      await _repo.deletePost(postId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return;
    }
    await fetchReports();
  }

  /// 댓글을 Firestore에서 실제 삭제합니다.
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _repo.deleteComment(postId, commentId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return;
    }
    await fetchReports();
  }

  /// 신고 상태를 초기화(해제)합니다.
  Future<void> clearReport(String type, String docId, {String? postId}) async {
    try {
      await _repo.clearReport(type, docId, postId: postId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return;
    }
    await fetchReports();
  }
}
