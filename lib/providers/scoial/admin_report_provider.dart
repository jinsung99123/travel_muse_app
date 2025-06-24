import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/scoial/admin_report_repository.dart';
import 'package:travel_muse_app/viewmodels/scoial/admin_report_view_model.dart';

final adminReportRepoProvider = Provider((ref) {
  return AdminReportRepository(FirebaseFirestore.instance);
});

final adminReportViewModelProvider =
    StateNotifierProvider<AdminReportViewModel, AsyncValue<List<Object>>>(
  (ref) {
    final repo = ref.watch(adminReportRepoProvider);
    return AdminReportViewModel(repo);
  },
);
