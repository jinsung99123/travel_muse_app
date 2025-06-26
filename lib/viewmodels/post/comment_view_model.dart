import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/repositories/post/comment_repository.dart';

class CommentViewModel extends StateNotifier<AsyncValue<List<Comment>>> {
  CommentViewModel(this._repo, this.postId)
    : super(const AsyncValue.loading()) {
    _listen();
  }
  final CommentRepository _repo;
  final String postId;

  void _listen() {
    _repo.getComments(postId).listen((comments) {
      state = AsyncValue.data(comments);
    });
  }

  Future<void> addComment(Comment comment) async {
    await _repo.addComment(postId, comment);
  }

  Future<void> toggleLike(String commentId, String userId) async {
    await _repo.toggleLike(postId, commentId, userId);
  }

  Future<void> reportComment(String commentId) async {
    await _repo.reportComment(postId, commentId);
  }
}
