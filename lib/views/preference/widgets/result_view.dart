import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/preference_test_view_model.dart';
import '../preference_test_page.dart';

class ResultView extends ConsumerWidget {
  final List<Map<String, String>> answers;
  final VoidCallback onRestart;

  const ResultView({super.key, required this.answers, required this.onRestart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferenceTestViewModelProvider);

    return state.when(
      data: (data) {
        final typeCode = data.$1;
        final description = data.$2;

        if (typeCode.isEmpty) {
          // 처음 진입 시 AI 호출
          ref
              .read(preferenceTestViewModelProvider.notifier)
              .classifyPersonality(answers);
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              '테스트 결과',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // 유형 결과 박스
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '당신의 타입: $typeCode',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 질문/답변 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final answer = answers[index];
                  final question = answer['question'] ?? '질문이 없습니다';
                  final selectedOption = answer['selectedOption'] ?? '선택이 없습니다';

                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        question,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      subtitle: Text(
                        '선택: $selectedOption',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(12),
                onPressed: onRestart,
                child: const Text(
                  '처음으로',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('에러: $e')),
    );
  }
}
