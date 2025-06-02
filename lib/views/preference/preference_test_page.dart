import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/widgets/option_button.dart';
import 'package:travel_muse_app/views/preference/widgets/question_card.dart';
import 'package:travel_muse_app/views/preference/widgets/result_view.dart';

const Color kPrimaryColor = Color(0xFF03A9F4);
const Color kSecondaryColor = Color(0xFF2979FF);
const Color kTertiaryColor = Color(0xFFBDBDBD);

class PreferenceTestPage extends StatefulWidget {
  const PreferenceTestPage({super.key});

  @override
  State<PreferenceTestPage> createState() => _PreferenceTestPageState();
}

class _PreferenceTestPageState extends State<PreferenceTestPage> {
  final List<Map<String, String>> _questions = [
    {
      'questionId': 'q1',
      'question': '어떤 여행지를 선호하시나요?',
      'type': 'preference',
      'details': '도시, 자연, 둘다',
    },
    {
      'questionId': 'q2',
      'question': '여행 스타일은 어떤가요?',
      'type': 'preference',
      'details': '계획형, 즉흥형, 둘다',
    },
    {
      'questionId': 'q3',
      'question': '여행 시 선호하는 교통수단은?',
      'type': 'preference',
      'details': '대중교통, 자가용, 도보',
    },
    {
      'questionId': 'q4',
      'question': '여행 동반자는 누구인가요?',
      'type': 'preference',
      'details': '혼자, 친구, 가족',
    },
    {
      'questionId': 'q5',
      'question': '여행 중 가장 기대되는 순간은?',
      'type': 'preference',
      'details': '맛집 탐방, 유명 명소, 현지 문화 체험',
    },
    {
      'questionId': 'q6',
      'question': '여행에서 사진을 얼마나 찍나요?',
      'type': 'preference',
      'details': '엄청 많이, 적당히, 별로 안찍어요',
    },
  ];

  int _currentIndex = 0;
  final List<Map<String, String>> _answers = [];

  Map<String, String> get _currentQuestion => _questions[_currentIndex];
  List<String> get _currentOptions => _currentQuestion['details']!.split(', ');

  void _onAnswerSelected(String selectedOption) {
    final answer = {
      'questionId': _currentQuestion['questionId']!,
      'selectedOption': selectedOption,
      'type': _currentQuestion['type']!,
      'details': _currentQuestion['details']!,
    };

    final existingIndex = _answers.indexWhere(
      (element) => element['questionId'] == _currentQuestion['questionId'],
    );

    if (existingIndex != -1) {
      _answers[existingIndex] = answer;
    } else {
      _answers.add(answer);
    }

    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = _questions.length;
      }
    });
  }

  void _onNextPressed() {
    final hasAnswered = _answers.any(
      (a) => a['questionId'] == _currentQuestion['questionId'],
    );

    if (!hasAnswered) return;

    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = _questions.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isFinished = _currentIndex >= _questions.length;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('성향 테스트', style: TextStyle(color: kTertiaryColor)),
        backgroundColor: kPrimaryColor.withOpacity(0.9),
      ),
      child: SafeArea(
        child:
            isFinished
                ? ResultView(
                  answers: _answers,
                  onRestart: () {
                    setState(() {
                      _currentIndex = 0;
                      _answers.clear();
                    });
                  },
                )
                : Column(
                  children: [
                    const SizedBox(height: 20),
                    QuestionCard(question: _currentQuestion['question']!),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _currentOptions.length,
                        itemBuilder: (context, index) {
                          final option = _currentOptions[index];
                          final color =
                              index % 2 == 0 ? kPrimaryColor : kSecondaryColor;
                          return OptionButton(
                            text: option,
                            color: color,
                            onPressed: () => _onAnswerSelected(option),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CupertinoButton(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _onNextPressed,
                        child: const Text(
                          '다음',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
