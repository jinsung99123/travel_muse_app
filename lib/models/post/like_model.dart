import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  Like({required this.postId, required this.userId, required this.likedAt});

  final String postId;
  final String userId;
  final DateTime likedAt;

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      likedAt: (json['likedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'postId': postId, 'userId': userId, 'likedAt': likedAt};
  }
}
