import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.isReported = false,
    this.reportCount = 0,
    this.likedUserIds = const [],
  });

  final String commentId;
  final String userId;
  final String content;
  final Timestamp createdAt;
  final String? parentId;
  final bool isReported;
  final int reportCount;
  final List<String> likedUserIds;

  factory Comment.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      commentId: doc.id,
      userId: data['userId'],
      content: data['content'],
      createdAt: data['createdAt'],
      parentId: data['parentId'],
      isReported: data['isReported'] ?? false,
      reportCount: data['reportCount'] ?? 0,
      likedUserIds: List<String>.from(data['likedUserIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
      'parentId': parentId,
      'isReported': isReported,
      'reportCount': reportCount,
      'likedUserIds': likedUserIds,
    };
  }
}
