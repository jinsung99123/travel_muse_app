import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_list_state_model.dart';
import 'package:travel_muse_app/repositories/post/post_list_repository.dart';

class PostListViewModel extends AutoDisposeAsyncNotifier<PostListState> {
  final _repository = PostListRepository();

  @override
  PostListState build() {
    fetchLatestPosts();
    return PostListState();
  }

  /// 포스트 리스트 초기값 상태 업데이트
  Future<void> fetchLatestPosts() async {
    state = const AsyncLoading();

    try {
      final posts = await _repository.fetchInitialPosts();
      state = AsyncData(state.value!.copyWith(posts: posts));
    } catch (e) {
      log('포스트 리스트 초기값 가져오기 실패 : $e');
    }
  }
}
