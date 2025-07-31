import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/viewmodels/post/liked_post_list_view_model.dart';

final likedPostListProvider =
    AsyncNotifierProvider<LikedPostListViewModel, List<Post>>(
      LikedPostListViewModel.new,
    );
