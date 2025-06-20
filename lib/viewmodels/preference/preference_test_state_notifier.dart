import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/preference/preference_test_model.dart';
import 'package:travel_muse_app/repositories/preference/preference_test_repository.dart';
import 'package:travel_muse_app/services/preference/preference_test_service.dart';

class PreferenceTestStateNotifier
    extends Notifier<AsyncValue<PreferenceTest?>> {
  final _repository = PreferenceTestRepository();
  final _service = PreferenceTestService();
  final user = FirebaseAuth.instance.currentUser;

  @override
  AsyncValue<PreferenceTest?> build() {
    return const AsyncValue.data(null);
  }

  /// Gemini API로 테스트 결과 분석
  Future<void> classifyTestOnly(
    List<Map<String, String>> answersRaw,
    BuildContext context,
  ) async {
    state = const AsyncValue.loading();
    try {
      final test = await _service.classify(answersRaw, context);
      state = AsyncValue.data(test);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Firestore에 테스트 저장 및 유저 문서에 ID 추가
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

  /// testId 기반으로 Firestore에서 테스트 결과 로드
  Future<void> loadTest(String testId) async {
    state = const AsyncValue.loading();
    try {
      final test = await _repository.loadTest(testId);
      state = AsyncValue.data(test);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 현재 로그인한 유저의 모든 테스트 리스트 불러오기
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

  /// 성향 테스트 삭제
  Future<void> deleteTest(String testId) async {
    state = const AsyncLoading();
    try {
      await _repository.deleteTest(testId);
      state = const AsyncValue.data(null); // 상태 초기화
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
