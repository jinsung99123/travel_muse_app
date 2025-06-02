import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../preference_test_page.dart';

class ResultView extends StatelessWidget {
  final List<Map<String, String>> answers;
  final VoidCallback onRestart;

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
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: answers.length,
            itemBuilder: (context, index) {
              final answer = answers[index];
              return Card(
                color: CupertinoColors.systemGrey6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    'Q${index + 1}: ${answer['questionId']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  subtitle: Text(
                    '선택: ${answer['selectedOption']}',
                    style: const TextStyle(color: Colors.black),
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
