import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/like_provider.dart';
import 'package:travel_muse_app/repositories/post/like_repository.dart';

class LikedPostListViewModel extends AsyncNotifier<List<Post>> {
  late final LikeRepository _repository;

  @override
  Future<List<Post>> build() async {
    _repository = ref.read(likeRepositoryProvider);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final posts = await _repository.fetchLikedPosts(userId);
    return posts.where((p) => p.isDeleted == false).toList();
  }
}
