import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/scoial/admin_report_repository.dart';
import 'package:travel_muse_app/viewmodels/scoial/admin_report_view_model.dart';

/// `AdminReportRepository`를 생성하여 제공하는 Provider.
final adminReportRepoProvider = Provider((ref) {
  return AdminReportRepository(FirebaseFirestore.instance);
});

/// 신고된 게시글 및 댓글 데이터를 관리하는 ViewModel Provider.
final adminReportViewModelProvider =
    StateNotifierProvider<AdminReportViewModel, AsyncValue<List<Object>>>(
  (ref) {
    final repo = ref.watch(adminReportRepoProvider);
    return AdminReportViewModel(repo);
  },
);
