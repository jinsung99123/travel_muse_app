import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/scoial/report_repository.dart';
import 'package:travel_muse_app/viewmodels/scoial/report_view_model.dart';

/// 신고 관련 데이터를 Firestore에 저장하는 Repository를 주입하는 Provider
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return FirebaseReportRepository(FirebaseFirestore.instance);
});

/// 신고 기능의 상태 및 로직을 관리하는 ViewModel Provider
final reportViewModelProvider =
    StateNotifierProvider<ReportViewModel, AsyncValue<void>>((ref) {
  final repo = ref.read(reportRepositoryProvider);
  return ReportViewModel(repo);
});
