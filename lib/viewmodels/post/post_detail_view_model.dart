import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/repositories/post/post_repository.dart';
import 'package:travel_muse_app/utills/logger_util.dart';
import 'package:travel_muse_app/viewmodels/post/post_detail_state.dart';

class PostDetailViewModel extends StateNotifier<PostDetailState> {
  PostDetailViewModel(this._repo) : super(const PostDetailState());

  final PostRepository _repo;

  Future<void> load({Post? post, String? postId}) async {
    try {
      state = state.copyWith(isLoading: true);

      Post? targetPost = post;

      if (targetPost == null && postId != null) {
        targetPost = await _repo.fetchPostById(postId);
      }

      if (targetPost == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      await _repo.incrementViewCount(targetPost.postId);

      final updatedPost = await _repo.fetchPostById(targetPost.postId);
      final user = await _repo.fetchUser(targetPost.userId);

      state = PostDetailState(
        post: updatedPost,
        nickname: user?.nickname ?? '알 수 없음',
        profileUrl: user?.profileImage,
        isLoading: false,
      );
    } catch (e, st) {
      logger.e('PostDetailViewModel load 실패', error: e, stackTrace: st);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    try {
      final updated = await _repo.fetchPostById(state.post?.postId ?? '');
      if (updated != null) {
        state = state.copyWith(post: updated);
      }
    } catch (e, st) {
      logger.e('PostDetailViewModel refresh 실패', error: e, stackTrace: st);
    }
  }
}
