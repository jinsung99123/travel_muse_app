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
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
