import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/repositories/post/post_repository.dart';

class PostViewModel extends StateNotifier<AsyncValue<void>> {
  PostViewModel(this._repository) : super(const AsyncData(null));

  final PostRepository _repository;

  /// 게시글 생성
  Future<void> createPost({
    required String title,
    required String content,
    required List<String> imageUrls,
    required List<String> tags,
  }) async {
    state = const AsyncLoading();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('로그인된 사용자가 없습니다.');

      final List<String> uploadedUrls = await _repository.uploadImages(
        imageUrls,
      );

      final post = Post(
        postId: _repository.generatePostId(),
        userId: user.uid,
        title: title,
        content: content,
        tags: tags,
        images: uploadedUrls,
        createAt: Timestamp.now(),
        commentCount: 0,
        likeCount: 0,
        isDeleted: false,
        isReposted: false,
        reportCount: 0,
      );

      await _repository.createPost(post);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// 게시글 수정
  Future<void> updatePost({
    required String postId,
    required String title,
    required String content,
    required List<String> imageUrls,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.updatePost(postId, title, content, imageUrls);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// 게시글 삭제
  Future<void> deletePost(String postId) async {
    state = const AsyncLoading();
    try {
      await _repository.deletePost(postId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
