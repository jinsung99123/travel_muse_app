import 'package:travel_muse_app/models/post/post_model.dart';

class PostListState {
  PostListState({this.posts = const [], this.filter});

  final List<Post> posts;
  final String? filter;

  PostListState copyWith({List<Post>? posts, String? filter}) {
    return PostListState(
      posts: posts ?? this.posts,
      filter: filter ?? this.filter,
    );
  }
}
