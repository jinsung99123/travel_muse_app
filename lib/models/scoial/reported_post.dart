import 'package:cloud_firestore/cloud_firestore.dart';

class ReportedPost {
  final String postId;
  final String userId;
  final String? nickname;
  final String content;
  final List<String> reasonCode;
  final List<String?> reasonText;
  final List<String> images;
  final DateTime createdAt;
  final bool isDeleted;
  final bool isReposted;
  final int reportCount;

  ReportedPost({
    required this.postId,
    required this.userId,
    required this.content,
    required this.reasonCode,
    required this.reasonText,
    required this.images,
    required this.createdAt,
    required this.isDeleted,
    required this.isReposted,
    required this.reportCount,
    this.nickname,
  });

  factory ReportedPost.fromJson(
    Map<String, dynamic> json,
    String postId, {
    required List<String> reasonCode,
    required List<String?> reasonText,
    String? nickname,
  }) {
    return ReportedPost(
      postId: postId,
      userId: json['userId'] ?? '',
      nickname: nickname,
      content: json['content'] ?? '',
      reasonCode: reasonCode,
      reasonText: reasonText,
      images: List<String>.from(json['images'] ?? []),
      createdAt: (json['createAt'] as Timestamp).toDate(),
      isDeleted: json['isDeleted'] ?? false,
      isReposted: json['isReposted'] ?? false,
      reportCount: json['reportCount'] ?? 0,
    );
  }
}
