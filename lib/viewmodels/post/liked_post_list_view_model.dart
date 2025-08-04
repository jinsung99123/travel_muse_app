import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/like_provider.dart';
import 'package:travel_muse_app/repositories/post/like_repository.dart';

class LikedPostListViewModel extends AsyncNotifier<List<Post>> {
  late final LikeRepository _repository;

  /// 좋아요한 게시물 목록을 불러와 비동기 상태로 관리.
  /// 삭제되지 않은 게시물만 필터링하여 반환.
  @override
  Future<List<Post>> build() async {
    _repository = ref.read(likeRepositoryProvider);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final posts = await _repository.fetchLikedPosts(userId);
    return posts.where((p) => p.isDeleted == false).toList();
  }
}
