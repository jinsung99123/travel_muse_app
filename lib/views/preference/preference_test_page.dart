import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/preference/widgets/preference_questions.dart';
import 'package:travel_muse_app/views/preference/widgets/previousButton.dart';
import 'widgets/question_card.dart';
import 'widgets/question_list_view.dart';
import 'widgets/next_button.dart';
import 'widgets/result_view.dart';

const Color kPrimaryColor = Color(0xFF03A9F4);
const Color kSecondaryColor = Color(0xFF2979FF);
const Color kTertiaryColor = Color(0xFFBDBDBD);

class PreferenceTestPage extends StatefulWidget {
  const PreferenceTestPage({super.key});

  @override
  State<PreferenceTestPage> createState() => _PreferenceTestPageState();
}

class _PreferenceTestPageState extends State<PreferenceTestPage> {
  int _currentIndex = 0;
  final List<Map<String, String>> _answers = [];

  Map<String, String> get _currentQuestion =>
      preferenceQuestions[_currentIndex];
  List<String> get _currentOptions => _currentQuestion['details']!.split(', ');

  void _onAnswerSelected(String selectedOption) {
    final answer = {
      'questionId': _currentQuestion['questionId']!,
      'question': _currentQuestion['question']!,
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

    _nextQuestion();
  }

  void _onNextPressed() {
    final hasAnswered = _answers.any(
      (a) => a['questionId'] == _currentQuestion['questionId'],
    );

    if (!hasAnswered) return;
    _nextQuestion();
  }

  void _previousQuestion() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentIndex < preferenceQuestions.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = preferenceQuestions.length;
      }
    });
  }

  void _restartTest() {
    setState(() {
      _currentIndex = 0;
      _answers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isFinished = _currentIndex >= preferenceQuestions.length;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('성향 테스트', style: TextStyle(color: kTertiaryColor)),
        backgroundColor: kPrimaryColor.withOpacity(0.9),
      ),
      child: SafeArea(
        child:
            isFinished
                ? ResultView(answers: _answers, onRestart: _restartTest)
                : Column(
                  children: [
                    const SizedBox(height: 20),
                    QuestionCard(question: _currentQuestion['question']!),
                    const SizedBox(height: 20),
                    QuestionListView(
                      options: _currentOptions,
                      onOptionSelected: _onAnswerSelected,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_currentIndex > 0)
                          PreviousButton(onPressed: _previousQuestion),
                        NextButton(onPressed: _onNextPressed),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
