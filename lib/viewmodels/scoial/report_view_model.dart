import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/scoial/report.dart';
import 'package:travel_muse_app/repositories/scoial/report_repository.dart';

class ReportViewModel extends StateNotifier<AsyncValue<void>> {
  ReportViewModel(this.repository) : super(const AsyncValue.data(null));

  final ReportRepository repository;

  /// 사용자의 신고 데이터를 처리
  /// 중복 신고 시 예외가 발생하며, 상태는 AsyncValue로 반영됩니다.
  Future<void> submit({
  required String targetType,
  required String targetId,
  required String reporterId,
  required String targetOwnerId,
  required String reasonCode,
  String? reasonText,
  String? postId,
}) async {
  state = const AsyncValue.loading();
  try {
    final report = Report(
      targetType: targetType,
      targetId: targetId,
      reporterId: reporterId,
      targetOwnerId: targetOwnerId,
      reasonCode: reasonCode,
      reasonText: reasonText,
      timestamp: DateTime.now(),
    );

    await repository.submitReport(report);

    final docRef = targetType == 'post'
        ? FirebaseFirestore.instance.collection('posts').doc(targetId)
        : FirebaseFirestore.instance
            .collection('posts')
            .doc(postId!)
            .collection('comments')
            .doc(targetId);

    // 현재 reportCount 조회
    final snapshot = await docRef.get();
    final currentCount = (snapshot.data()?['reportCount'] ?? 0) + 1;

    // reportCount 증가 및 isReposted 처리
    await docRef.update({
      'reportCount': currentCount,
      'isReposted': true,
    });

    // 자동 삭제 처리
    if (currentCount >= 3) {
      if (targetType == 'post') {
        await docRef.update({'isDeleted': true});
      } else {
        await docRef.delete(); // 댓글은 완전 삭제
      }
    }

    state = const AsyncValue.data(null);
  } catch (e, st) {
    state = AsyncValue.error(e, st);
  }
}

}
