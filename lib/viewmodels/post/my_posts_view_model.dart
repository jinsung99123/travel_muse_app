import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/repositories/post/post_list_repository.dart';

class MyPostsViewModel extends AutoDisposeAsyncNotifier<List<Post>> {
  final _repository = PostListRepository();
  final _logger = Logger();
  @override
  Future<List<Post>> build() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      return await _repository.fetchPostsByUserId(user.uid);
    } catch (e) {
      _logger.e('MyPostsViewModel build 실패', error: e);
      rethrow;
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
