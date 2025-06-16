import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';
import 'package:travel_muse_app/repositories/preference_test_repository.dart';

final preferenceTestViewModelProvider =
    NotifierProvider<PreferenceTestViewModel, AsyncValue<PreferenceTest?>>(
      () => PreferenceTestViewModel(),
    );

class PreferenceTestViewModel extends Notifier<AsyncValue<PreferenceTest?>> {
  final _repository = PreferenceTestRepository();

  @override
  AsyncValue<PreferenceTest?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> classifyTestOnly(
    List<Map<String, String>> answersRaw,
    BuildContext context,
  ) async {
    state = const AsyncValue.loading();
    try {
      final test = await _repository.classifyTestOnly(answersRaw, context);
      state = AsyncValue.data(test);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveTestToFirestore() async {
    final current = state.value;
    if (current == null) return;

    try {
      final saved = await _repository.saveOrUpdateTest(current);
      state = AsyncValue.data(saved);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadTest(String testId) async {
    state = const AsyncValue.loading();
    try {
      final test = await _repository.loadTest(testId);
      state = AsyncValue.data(test);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
