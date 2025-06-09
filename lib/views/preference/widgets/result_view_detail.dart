import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';
import 'package:travel_muse_app/providers/preference_test_provider.dart';
import 'package:travel_muse_app/views/preference/widgets/preference_questions.dart';
import 'package:travel_muse_app/views/preference/widgets/result_action_buttons.dart';

class ResultViewDetail extends ConsumerWidget {
  const ResultViewDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferenceTestViewModelProvider);

    if (state.value == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<PreferenceAnswer> answers = state.value!.answers;

    final Map<String, String> referenceQuestionTexts = {
      for (final q in preferenceQuestions) q['questionId']!: q['question']!,
    };

    return Scaffold(
      backgroundColor: Colors.white,

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                '사용자님이 선택하신\n선택지들이에요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard',
                  color: Color(0xFF26272A),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '선택지를 변경하려면 돌아가기 버튼을 눌러\n테스트 화면으로 돌아가서 변경해주세요',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                  color: Color(0xFF7C878C),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
          ...answers.map((answer) {
            final question =
                referenceQuestionTexts[answer.questionId] ?? '알 수 없는 질문';
            final selectedOption = answer.selectedOption;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF48CDFD),
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '선택: $selectedOption',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
          ResultActionButtons(
            onRestart: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
