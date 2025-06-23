import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.postId,
    required this.userId,
    required this.title,
    required this.content,
    required this.images,
    required this.createAt,
    required this.commentCount,
    required this.likeCount,
    required this.isDeleted,
    required this.isReposted,
    required this.reportCount,
    required this.tags,
  });
  final String postId;
  final String userId;
  final String title;
  final String content;
  final List<String> images;
  final List<String> tags;
  final Timestamp createAt;
  final int commentCount;
  final int likeCount;
  final bool isDeleted;
  final bool isReposted;
  final int reportCount;

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      createAt: map['createAt'] ?? Timestamp.now(),
      commentCount: map['commentCount'] ?? 0,
      likeCount: map['likeCount'] ?? 0,
      isDeleted: map['isDeleted'] ?? false,
      isReposted: map['isReposted'] ?? false,
      reportCount: map['reportCount'] ?? 0,
      title: map['title'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'title': title,
      'content': content,
      'images': images,
      'createAt': createAt,
      'commentCount': commentCount,
      'likeCount': likeCount,
      'isDeleted': isDeleted,
      'isReposted': isReposted,
      'reportCount': reportCount,
      'tags': tags,
    };
  }
}
