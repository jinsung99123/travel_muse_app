import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';
import 'package:travel_muse_app/repositories/preference_test_repository.dart';
import 'package:travel_muse_app/viewmodels/preference_test_view_model.dart';

final preferenceTestProvider =
    NotifierProvider<PreferenceTestViewModel, AsyncValue<PreferenceTest?>>(
      () => PreferenceTestViewModel(),
    );
final preferenceTestStreamProvider =
    StreamProvider.family<PreferenceTest, String>((ref, testId) {
      final repository = PreferenceTestRepository();
      return repository.watchTest(testId);
    });
final preferenceTestViewModelProvider =
    NotifierProvider<PreferenceTestViewModel, AsyncValue<PreferenceTest?>>(
      () => PreferenceTestViewModel(),
    );
