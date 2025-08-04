import 'package:travel_muse_app/models/post/post_model.dart';

class PostDetailState {
  const PostDetailState({
    this.post,
    this.nickname,
    this.profileUrl,
    this.typeCode,
    this.isLoading = false,
  });
  final Post? post;
  final String? nickname;
  final String? profileUrl;
  final String? typeCode;
  final bool isLoading;

  PostDetailState copyWith({
    Post? post,
    String? nickname,
    String? profileUrl,
    String? typeCode,
    bool? isLoading,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      nickname: nickname ?? this.nickname,
      profileUrl: profileUrl ?? this.profileUrl,
      typeCode: typeCode ?? this.typeCode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
