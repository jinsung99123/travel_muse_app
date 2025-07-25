import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/post/post_provider.dart';
import 'package:travel_muse_app/viewmodels/post/post_detail_state.dart';
import 'package:travel_muse_app/viewmodels/post/post_detail_view_model.dart';

final postDetailViewModelProvider =
    StateNotifierProvider<PostDetailViewModel, PostDetailState>((ref) {
      final repo = ref.watch(postRepositoryProvider);
      return PostDetailViewModel(repo);
    });
