import 'package:cloud_firestore/cloud_firestore.dart';

class FormatTimeAgo {
  static String formatTimeAgo({required DateTime now, required Timestamp createdAt}) {
    final diff = now.difference(createdAt.toDate());

    if (diff.inSeconds <= 0) {
      return '방금 전';
    } else if (diff.inSeconds < 60) {
      return '${diff.inSeconds}초 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks주 전';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months달 전';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years년 전';
    }
  }
}
