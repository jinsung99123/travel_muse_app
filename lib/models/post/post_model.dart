import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.postId,
    required this.userId,
    required this.title,
    required this.content,
    required this.images,
    this.thumbnail,
    required this.createAt,
    required this.commentCount,
    required this.likeCount,
    required this.viewCount,
    required this.isDeleted,
    required this.isReposted,
    required this.reportCount,
    required this.tags,
    required this.place,
  });
  final String postId;
  final String userId;
  final String title;
  final String content;
  final List<String> images;
  final String? thumbnail;
  final List<String> tags;
  final Timestamp createAt;
  final int commentCount;
  final int likeCount;
  final int viewCount;
  final bool isDeleted;
  final bool isReposted;
  final int reportCount;
  final Map<String, dynamic>? place;

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      thumbnail: map['thumbnail'],
      tags: List<String>.from(map['tags'] ?? []),
      createAt:
          map['createAt'] is Timestamp ? map['createAt'] as Timestamp : Timestamp.now(),
      commentCount: map['commentCount'] ?? 0,
      likeCount: map['likeCount'] ?? 0,
      viewCount: map['viewCount'] ?? 0,
      isDeleted: map['isDeleted'] ?? false,
      isReposted: map['isReposted'] ?? false,
      reportCount: map['reportCount'] ?? 0,
      title: map['title'] ?? '',
      place: map['place'],
    );
  }
  Map<String, dynamic> toMap({required bool isNew}) {
    return {
      'postId': postId,
      'userId': userId,
      'title': title,
      'content': content,
      'images': images,
      'thumbnail': thumbnail,
      'createAt': isNew ? FieldValue.serverTimestamp() : createAt,
      'commentCount': commentCount,
      'likeCount': likeCount,
      'viewCount': viewCount,
      'isDeleted': false,
      'isReposted': isReposted,
      'reportCount': reportCount,
      'tags': tags,
      'place': place,
    };
  }

  Post copyWith({
    String? postId,
    String? userId,
    String? title,
    String? content,
    List<String>? images,
    List<String>? tags,
    Timestamp? createAt,
    int? commentCount,
    int? likeCount,
    int? viewCount,
    bool? isDeleted,
    bool? isReposted,
    int? reportCount,
    Map<String, dynamic>? place,
  }) {
    return Post(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      createAt: createAt ?? this.createAt,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      viewCount: viewCount ?? this.viewCount,
      isDeleted: isDeleted ?? this.isDeleted,
      isReposted: isReposted ?? this.isReposted,
      reportCount: reportCount ?? this.reportCount,
      place: place ?? this.place,
    );
  }
}
