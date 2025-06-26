import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_list_state_model.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/repositories/post/post_list_repository.dart';

class PostListViewModel extends AutoDisposeAsyncNotifier<PostListState> {
  final _repository = PostListRepository();

  @override
  PostListState build() {
    fetchInitialPosts();
    return PostListState();
  }

  /// 포스트 리스트 초기값 상태 업데이트
  Future<void> fetchInitialPosts() async {
    state = const AsyncLoading();

    try {
      final posts = await _repository.fetchInitialPosts();
      state = AsyncData(state.value!.copyWith(posts: posts));
    } catch (e) {
      log('포스트 리스트 초기값 가져오기 실패 : $e');
    }
  }

  Future<void> fetchNewPosts() async {
    try {
      final currentPosts = state.value?.posts ?? [];

      List<Post> newPosts;

      if (currentPosts.isEmpty) {
        newPosts = await _repository.fetchInitialPosts();
      } else {
        final latestCreateAt = currentPosts.first.createAt;
        newPosts = await _repository.fetchNewPostsAfter(latestCreateAt);

        final existingIds = currentPosts.map((post) => post.postId).toSet();
        newPosts = newPosts.where((post) => !existingIds.contains(post.postId)).toList();

        newPosts = [...newPosts, ...currentPosts];
      }

      state = AsyncData(state.value!.copyWith(posts: newPosts));
    } catch (e) {
      log('당겨서 새로고침 실패 : $e');
    }
  }

  Future<void> fetchOldPosts() async {
    try {
      final currentPosts = state.value?.posts ?? [];

      List<Post> newPosts;

      if (currentPosts.isEmpty) {
        newPosts = await _repository.fetchInitialPosts();
      } else {
        final oldestCreateAt = currentPosts.last.createAt;
        newPosts = await _repository.fetchOldPostsBefore(oldestCreateAt);

        final existingIds = currentPosts.map((post) => post.postId).toSet();
        newPosts = newPosts.where((post) => !existingIds.contains(post.postId)).toList();

        newPosts = [...currentPosts, ...newPosts];
      }

      state = AsyncData(state.value!.copyWith(posts: newPosts));
    } catch (e) {
      log('무한 스크롤 실패 : $e');
    }
  }

  /// 필터 상태 업데이트
  void setFilterState(String? filter) {
    state = AsyncData(state.value!.copyWith(filter: filter));
  }
}
