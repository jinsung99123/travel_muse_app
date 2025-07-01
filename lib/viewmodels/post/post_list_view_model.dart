import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_list_state_model.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/repositories/post/post_list_repository.dart';

class PostListViewModel
    extends AutoDisposeAsyncNotifier<PostListState> {
  final _repository = PostListRepository();

  @override
  PostListState build() {
    refreshPosts();
    return PostListState();
  }

  void addPost(Post post) {
    final currentState = state.value;
    if (currentState == null) return;

    final exists = currentState.posts.any(
      (p) => p.postId == post.postId,
    );
    if (exists) return;

    setFilterState(null);

    // final updatedPosts = [post, ...currentState.posts];

    // state = AsyncData(currentState.copyWith(posts: updatedPosts));
  }

  void updatePost(Post updatedPost) {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedPosts =
        currentState.posts.map((post) {
          return post.postId == updatedPost.postId
              ? updatedPost
              : post;
        }).toList();

    state = AsyncData(currentState.copyWith(posts: updatedPosts));
  }

  /// 포스트 리스트 초기화 => filter=null
  Future<void> fetchInitialPosts() async {
    state = const AsyncLoading();

    try {
      final posts = await _repository.fetchInitialPosts(filter: null);
      state = AsyncData(PostListState(posts: posts, filter: null));
    } catch (e) {
      log('포스트 리스트 초기값 가져오기 실패 : $e');
    }
  }

  /// 포스트 리스트 새로고침
  Future<void> refreshPosts() async {
    state = const AsyncLoading();

    try {
      final filter = state.value?.filter;
      final posts = await _repository.fetchInitialPosts(
        filter: filter,
      );
      state = AsyncData(state.value!.copyWith(posts: posts));
    } catch (e) {
      log('포스트 리스트 새로고침 실패 : $e');
    }
  }

  Future<void> fetchNewPosts() async {
    try {
      final currentPosts = state.value?.posts ?? [];
      final filter = state.value?.filter;

      List<Post> newPosts;

      if (currentPosts.isEmpty) {
        newPosts = await _repository.fetchInitialPosts(
          filter: filter,
        );
      } else {
        final latestCreateAt = currentPosts.first.createAt;
        newPosts = await _repository.fetchNewPostsAfter(
          latestCreateAt: latestCreateAt,
          filter: filter,
        );

        final existingIds =
            currentPosts.map((post) => post.postId).toSet();
        newPosts =
            newPosts
                .where((post) => !existingIds.contains(post.postId))
                .toList();

        newPosts = [...newPosts, ...currentPosts];
      }

      // isDeleted 필드 기준으로 필터링
      // final filteredPosts =
      //     newPosts.where((post) => post.isDeleted == false).toList();

      state = AsyncData(state.value!.copyWith(posts: newPosts));
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
        newPosts = await _repository.fetchInitialPosts(
          filter: filter,
        );
      } else {
        final oldestCreateAt = currentPosts.last.createAt;
        newPosts = await _repository.fetchOldPostsBefore(
          oldestCreateAt: oldestCreateAt,
          filter: filter,
        );

        final existingIds =
            currentPosts.map((post) => post.postId).toSet();
        newPosts =
            newPosts
                .where((post) => !existingIds.contains(post.postId))
                .toList();

        newPosts = [...currentPosts, ...newPosts];
      }
      // final filteredPosts =
      //     newPosts.where((post) => post.isDeleted == false).toList();

      state = AsyncData(state.value!.copyWith(posts: newPosts));
    } catch (e) {
      log('무한 스크롤 실패 : $e');
    }
  }

  /// 필터 상태 업데이트 및 포스트 재로드
  void setFilterState(String? filter) async {
    state = AsyncData(state.value!.copyWith(filter: filter));
    try {
      state = const AsyncLoading();
      final posts = await _repository.fetchInitialPosts(
        filter: filter,
      );
      state = AsyncData(PostListState(posts: posts, filter: filter));
    } catch (e) {
      log('필터 초기화 후 fetch 실패: $e');
    }
  }
}
