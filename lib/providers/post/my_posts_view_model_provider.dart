import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/viewmodels/post/my_posts_view_model.dart';

final myPostsViewModelProvider =
    AutoDisposeAsyncNotifierProvider<MyPostsViewModel, List<Post>>(
      () => MyPostsViewModel(),
    );
