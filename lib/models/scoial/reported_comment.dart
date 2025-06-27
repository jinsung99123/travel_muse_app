import 'package:cloud_firestore/cloud_firestore.dart';

class ReportedComment {
  final String commentId;
  final String userId;
  final String? nickname;
  final String content;
  final List<String> reasonCode;
  final List<String?> reasonText;
  final DateTime createdAt;
  final bool isReposted;
  final int reportCount;
  final String postId;

  ReportedComment({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.reasonCode,
    required this.reasonText,
    required this.createdAt,
    required this.isReposted,
    required this.reportCount,
    required this.postId,
    this.nickname,
  });

  factory ReportedComment.fromJson(
    Map<String, dynamic> json,
    String postId,
    String commentId,
    List<String> reasonCode,
    List<String?> reasonText, {
    String? nickname,
  }) {
    return ReportedComment(
      commentId: commentId,
      postId: postId,
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isReposted: json['isReposted'] ?? false,
      reportCount: json['reportCount'] ?? 0,
      reasonCode: reasonCode,
      reasonText: reasonText,
      nickname: nickname,
    );
  }
}
