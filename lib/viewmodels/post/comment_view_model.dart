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

  /// 댓글 스트림을 구독하여 상태를 실시간으로 업데이트
  void _listen() {
    _repo.getComments(postId).listen((comments) {
      state = AsyncValue.data(comments);
    });
  }

  /// 새로운 댓글 추가
  Future<void> addComment(Comment comment) async {
    await _repo.addComment(postId, comment);
  }

  /// 특정 댓글에 좋아요 토글 (좋아요/취소)
  Future<void> toggleLike(String commentId, String userId) async {
    await _repo.toggleLike(postId, commentId, userId);
  }

  /// 댓글 신고 (신고 횟수 증가 및 일정 횟수 초과 시 isReported 처리)
  Future<void> reportComment(String commentId) async {
    await _repo.reportComment(postId, commentId);
  }

  /// 댓글 삭제 (대댓글 포함하여 전체 삭제)
  Future<void> deleteComment(String commentId) async {
    await _repo.deleteComment(postId, commentId);
  }

  /// 댓글 작성자의 닉네임 및 프로필 이미지 불러오기
  Future<Map<String, String>> getUserInfo(String userId) {
    return _repo.fetchUserInfo(userId);
  }
}
