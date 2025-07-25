import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/post/like_repository.dart';
import 'package:travel_muse_app/viewmodels/post/like_view_model.dart';

final likeRepositoryProvider = Provider<LikeRepository>((ref) {
  return LikeRepositoryImpl(FirebaseFirestore.instance);
});

final likeViewModelProvider =
    StateNotifierProvider.family<LikeViewModel, bool, LikeViewModelParams>((
      ref,
      params,
    ) {
      final repository = ref.watch(likeRepositoryProvider);
      return LikeViewModel(
        repository: repository,
        postId: params.postId,
        userId: params.userId,
      );
    });

class LikeViewModelParams {
  LikeViewModelParams({required this.postId, required this.userId});
  final String postId;
  final String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikeViewModelParams &&
          runtimeType == other.runtimeType &&
          postId == other.postId &&
          userId == other.userId;

  @override
  int get hashCode => postId.hashCode ^ userId.hashCode;
}
