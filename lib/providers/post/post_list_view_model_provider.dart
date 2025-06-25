import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_list_state_model.dart';
import 'package:travel_muse_app/viewmodels/post/post_list_view_model.dart';

final postListViewModelProvider =
    AutoDisposeAsyncNotifierProvider<PostListViewModel, PostListState>(
      () => PostListViewModel(),
    );
