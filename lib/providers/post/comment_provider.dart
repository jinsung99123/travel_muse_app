import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/repositories/post/comment_repository.dart';
import 'package:travel_muse_app/viewmodels/post/comment_view_model.dart';

final commentRepositoryProvider = Provider((ref) {
  return CommentRepository(FirebaseFirestore.instance);
});

final commentViewModelProvider = StateNotifierProvider.family<
  CommentViewModel,
  AsyncValue<List<Comment>>,
  String
>((ref, postId) {
  final repo = ref.read(commentRepositoryProvider);
  return CommentViewModel(repo, postId);
});
