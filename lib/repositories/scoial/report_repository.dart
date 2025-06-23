import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/scoial/report.dart';

/// 신고 데이터를 저장하는 Repository 추상 클래스
abstract class ReportRepository {
  Future<void> submitReport(Report report);
}
/// Firebase Firestore 기반의 신고 Repository 구현체.
class FirebaseReportRepository implements ReportRepository {
  FirebaseReportRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  /// 신고 데이터를 Firestore에 저장
  /// 중복 신고 방지 쿼리
  Future<void> submitReport(Report report) async {
    final dupQuery = await _firestore
        .collection('reports')
        .where('targetId', isEqualTo: report.targetId)
        .where('reporterId', isEqualTo: report.reporterId)
        .get();

    if (dupQuery.docs.isNotEmpty) {
      throw Exception('이미 신고한 콘텐츠입니다.');
    }

    await _firestore.collection('reports').add(report.toJson());
  }
}

