import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/post/post_repository.dart';
import 'package:travel_muse_app/viewmodels/post/post_view_model.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final postViewModelProvider =
    StateNotifierProvider<PostViewModel, AsyncValue<void>>((ref) {
      final repository = ref.watch(postRepositoryProvider);
      return PostViewModel(repository);
    });
