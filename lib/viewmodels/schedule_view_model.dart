import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plans.dart';

class ScheduleViewModel extends StateNotifier<AsyncValue<List<Plans>>> {
  ScheduleViewModel() : super(const AsyncLoading()) {
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('plans').get();

      final plans = snapshot.docs.map(
        (doc) => Plans.fromJson(doc.id, doc.data()),
      ).toList();

      state = AsyncData(plans);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
