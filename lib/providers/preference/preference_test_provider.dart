import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/preference/preference_test_model.dart';
import 'package:travel_muse_app/repositories/preference/preference_test_repository.dart';
import 'package:travel_muse_app/viewmodels/preference/preference_test_state_notifier.dart';

// 상태관리용 Notifier
final preferenceTestStateNotifierProvider =
    NotifierProvider<PreferenceTestStateNotifier, AsyncValue<PreferenceTest?>>(
      () => PreferenceTestStateNotifier(),
    );

// 실시간 스트리밍 조회용
final preferenceTestStreamProvider =
    StreamProvider.family<PreferenceTest, String>((ref, testId) {
      final repository = PreferenceTestRepository();
      return repository.watchTest(testId);
    });
