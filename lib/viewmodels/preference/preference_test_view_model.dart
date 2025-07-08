import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/preference/preference_test_provider.dart';
import 'package:travel_muse_app/views/preference/preference_loading_page.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';
import 'package:travel_muse_app/views/preference/widgets/preference_questions.dart';

class PreferenceTestViewModel {
  PreferenceTestViewModel(this.ref);
  final WidgetRef ref;

  /// 현재 인덱스의 질문 반환
  Map<String, String> getCurrentQuestion(int index) {
    return preferenceQuestions[index];
  }

  /// 질문에서 보기 항목 리스트 추출
  List<String> getOptions(Map<String, String> question) {
    return question['details']!.split(', ');
  }

  /// answers 배열에 선택된 답변 저장 (기존 답변 있으면 덮어쓰기)
  void saveAnswer({
    required List<Map<String, String>> answers,
    required Map<String, String> question,
    required List<String> selectedOptions,
  }) {
    final answer = {
      'questionId': question['questionId']!,
      'question': question['question']!,
      'selectedOption': selectedOptions.join(', '),
      'type': question['type']!,
      'details': question['details']!,
    };

    final existingIndex = answers.indexWhere(
      (element) => element['questionId'] == question['questionId'],
    );

    if (existingIndex != -1) {
      answers[existingIndex] = answer;
    } else {
      answers.add(answer);
    }
  }

  /// 다음 질문으로 이동하거나, 마지막이면 로딩 페이지로 이동
  Future<void> goToNext({
    required BuildContext context,
    required int currentIndex,
    required List<Map<String, String>> answers,
    required VoidCallback onRestart,
    required VoidCallback incrementIndex,
  }) async {
    if (currentIndex < preferenceQuestions.length - 1) {
      incrementIndex();
    } else {
      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  PreferenceLoadingPage(answers: answers, onRestart: onRestart),
        ),
      );
    }
  }

  /// 테스트 초기화 및 첫 페이지로 이동
  void restartTest(BuildContext context) {
    ref.invalidate(preferenceTestStateNotifierProvider);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PreferenceTestPage()),
    );
  }
}
