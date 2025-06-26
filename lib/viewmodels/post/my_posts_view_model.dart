import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/repositories/post/post_list_repository.dart';

class MyPostsViewModel extends AutoDisposeAsyncNotifier<List<Post>> {
  final _repository = PostListRepository();

  @override
  Future<List<Post>> build() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      return await _repository.fetchPostsByUserId(user.uid);
    } catch (e) {
      log('MyPostsViewModel build 실패: $e');
      // 에러 발생 시 throw 해야 오류로 처리됨
      throw e;
    }
  }

  /// 현재 유저의 post 목록 상태에 업데이트
  Future<void> fetchMyPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final myPosts = await _repository.fetchPostsByUserId(user.uid);
      state = AsyncData(myPosts);
    } catch (e) {
      log('현재 유저 post 목록 가져오기 실패 : $e');
      state = AsyncError(e, StackTrace.current);
    }
  }
}
