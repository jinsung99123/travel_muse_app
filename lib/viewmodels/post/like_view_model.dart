import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:travel_muse_app/repositories/post/like_repository.dart';

final Logger _logger = Logger();

class LikeViewModel extends StateNotifier<bool> {
  LikeViewModel({
    required LikeRepository repository,
    required this.postId,
    required this.userId,
  }) : _repository = repository,
       super(false) {
    _checkIfLiked(); // 초기 상태 확인
  }

  final LikeRepository _repository;
  final String postId;
  final String userId;

  /// 사용자가 해당 게시글에 좋아요를 눌렀는지 확인
  Future<void> _checkIfLiked() async {
    final liked = await _repository.isPostLikedByUser(
      postId: postId,
      userId: userId,
    );
    state = liked;
  }

  /// 좋아요 상태를 토글 (on/off)
  Future<void> toggleLike() async {
    try {
      if (state) {
        await _repository.removeLike(postId: postId, userId: userId);
        state = false;
      } else {
        await _repository.addLike(postId: postId, userId: userId);
        state = true;
      }
    } catch (e, s) {
      _logger.e('Like toggle failed', error: e, stackTrace: s);
    }
  }
}
