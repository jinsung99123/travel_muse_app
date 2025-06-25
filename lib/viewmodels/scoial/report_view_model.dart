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
    String? postId, // 댓글일 경우에만 필요
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
      ///신고 대상 문서 업데이트
      final docRef =
          targetType == 'post'
              ? FirebaseFirestore.instance.collection('posts').doc(targetId)
              : FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId!) // 댓글일 경우 postId가 필요
                  .collection('comments')
                  .doc(targetId);

      await docRef.update({
        'reportCount': FieldValue.increment(1),
        'isReposted': true,
      });

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
