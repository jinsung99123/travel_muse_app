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
      final filter = state.value?.filter;
      final posts = await _repository.fetchInitialPosts(filter: filter);
      final filteredPosts =
          posts.where((post) => post.isDeleted == false).toList();
      state = AsyncData(state.value!.copyWith(posts: filteredPosts));
    } catch (e) {
      log('포스트 리스트 초기값 가져오기 실패 : $e');
    }
  }

  Future<void> fetchNewPosts() async {
    try {
      final currentPosts = state.value?.posts ?? [];
      final filter = state.value?.filter;

      List<Post> newPosts;

      if (currentPosts.isEmpty) {
        newPosts = await _repository.fetchInitialPosts(filter: filter);
      } else {
        final latestCreateAt = currentPosts.first.createAt;
        newPosts = await _repository.fetchNewPostsAfter(
          latestCreateAt: latestCreateAt,
          filter: filter,
        );

        final existingIds = currentPosts.map((post) => post.postId).toSet();
        newPosts =
            newPosts
                .where((post) => !existingIds.contains(post.postId))
                .toList();

        newPosts = [...newPosts, ...currentPosts];
      }

      // isDeleted 필드 기준으로 필터링
      final filteredPosts =
          newPosts.where((post) => post.isDeleted == false).toList();

      state = AsyncData(state.value!.copyWith(posts: filteredPosts));
    } catch (e) {
      log('당겨서 새로고침 실패 : $e');
    }
  }

  Future<void> fetchOldPosts() async {
    try {
      final currentPosts = state.value?.posts ?? [];
      final filter = state.value?.filter;

      List<Post> newPosts;

      if (currentPosts.isEmpty) {
        newPosts = await _repository.fetchInitialPosts(filter: filter);
      } else {
        final oldestCreateAt = currentPosts.last.createAt;
        newPosts = await _repository.fetchOldPostsBefore(
          oldestCreateAt: oldestCreateAt,
          filter: filter,
        );

        final existingIds = currentPosts.map((post) => post.postId).toSet();
        newPosts =
            newPosts
                .where((post) => !existingIds.contains(post.postId))
                .toList();

        newPosts = [...currentPosts, ...newPosts];
      }
      final filteredPosts =
          newPosts.where((post) => post.isDeleted == false).toList();

      state = AsyncData(state.value!.copyWith(posts: filteredPosts));
    } catch (e) {
      log('무한 스크롤 실패 : $e');
    }
  }

  /// 필터 상태 업데이트
  void setFilterState(String? filter) {
    state = AsyncData(state.value!.copyWith(filter: filter));
    filterPostsByTag(filter);
  }

  /// 현재 state의 posts 중 filter에 해당하는 태그가 있는 포스트만 남김
  void filterPostsByTag(String? filter) {
    final currentState = state.value;

    if (currentState == null) return;

    if (filter == null) {
      state = AsyncData(currentState);
      return;
    }

    final filteredPosts =
        currentState.posts.where((post) => post.tags.contains(filter)).toList();

    state = AsyncData(
      currentState.copyWith(posts: filteredPosts, filter: filter),
    );
  }
}
