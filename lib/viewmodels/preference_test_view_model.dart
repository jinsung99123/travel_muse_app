import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser;

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
      await _repository.addTestIdToUser(testId: current.testId);
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

  Future<List<PreferenceTest>> fetchTestsByUserId() async {
    if (user == null) return [];
    try {
      final tests = await _repository.fetchTestsByUserId(user!.uid);
      return tests;
    } catch (e) {
      log('유저 테스트 결과 목록 로드 실패 : $e');
      return [];
    }
  }
}
