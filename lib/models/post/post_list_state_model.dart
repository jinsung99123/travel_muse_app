import 'package:travel_muse_app/models/post/post_model.dart';

class PostListState {
  PostListState({this.posts = const []});

  final List<Post> posts;

  PostListState copyWith({List<Post>? posts}) {
    return PostListState(posts: posts ?? this.posts);
  }
}
