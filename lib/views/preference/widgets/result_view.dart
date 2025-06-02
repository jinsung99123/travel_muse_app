import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class ResultView extends StatelessWidget {
  final List<Map<String, String>> answers;
  final VoidCallback onRestart;

  //TODO: 임시로 결과 유형 & 설명 (나중에 AI 응답으로 대체할 것!)
  final String testType = '계획형 여행자';
  final String testDescription =
      '여행을 철저하게 계획하고 준비하는 성향입니다.\n항상 계획표를 작성하며, 여행지 정보를 수집하는 걸 즐깁니다.';

  const ResultView({super.key, required this.answers, required this.onRestart});

  @override
  Widget build(BuildContext context) {
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
        // 유형 결과 표시
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
                testType,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                testDescription,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // 질문 + 선택값 리스트
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
            child: const Text('처음으로', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
