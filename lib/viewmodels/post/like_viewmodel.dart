import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/post/like_repository.dart';

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

  Future<void> _checkIfLiked() async {
    final liked = await _repository.isPostLikedByUser(
      postId: postId,
      userId: userId,
    );
    state = liked;
  }

  Future<void> toggleLike() async {
    if (state) {
      await _repository.removeLike(postId: postId, userId: userId);
      state = false;
    } else {
      await _repository.addLike(postId: postId, userId: userId);
      state = true;
    }
  }
}
