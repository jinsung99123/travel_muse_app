import 'package:travel_muse_app/models/post/post_model.dart';

class PostDetailState {
  const PostDetailState({
    this.post,
    this.nickname,
    this.profileUrl,
    this.isLoading = false,
  });
  final Post? post;
  final String? nickname;
  final String? profileUrl;
  final bool isLoading;

  PostDetailState copyWith({
    Post? post,
    String? nickname,
    String? profileUrl,
    bool? isLoading,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      nickname: nickname ?? this.nickname,
      profileUrl: profileUrl ?? this.profileUrl,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
