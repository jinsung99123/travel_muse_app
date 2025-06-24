import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/scoial/admin_report_repository.dart';

class AdminReportViewModel extends StateNotifier<AsyncValue<List<Object>>> {
  AdminReportViewModel(this._repo) : super(const AsyncValue.loading()) {
    fetchReports();
  }

  final AdminReportRepository _repo;

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

  Future<void> deletePost(String postId) async {
    try {
      await _repo.deletePost(postId);
    } catch (e, st) {
      state = AsyncValue.error(e, st); return;
    }
    await fetchReports();
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _repo.deleteComment(postId, commentId);
    } catch (e, st) {
      state = AsyncValue.error(e, st); return;
    }
    await fetchReports();
  }

  Future<void> clearReport(String type, String docId, {String? postId}) async {
    try {
      await _repo.clearReport(type, docId, postId: postId);
    } catch (e, st) {
      state = AsyncValue.error(e, st); return;
    }
    await fetchReports();
  }
}
