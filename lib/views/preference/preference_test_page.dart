import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/preference/preference_test_provider.dart';
import 'package:travel_muse_app/views/preference/preference_loading_page.dart';
import 'package:travel_muse_app/views/preference/widgets/next_button.dart';
import 'package:travel_muse_app/views/preference/widgets/page_indicator_bar.dart';
import 'package:travel_muse_app/views/preference/widgets/preference_questions.dart';
import 'package:travel_muse_app/views/preference/widgets/question_card.dart';
import 'package:travel_muse_app/views/preference/widgets/question_list_view.dart';
import 'package:travel_muse_app/views/preference/widgets/result_view.dart';

class PreferenceTestPage extends ConsumerStatefulWidget {
  const PreferenceTestPage({super.key});

  @override
  ConsumerState<PreferenceTestPage> createState() => _PreferenceTestPageState();
}

class _PreferenceTestPageState extends ConsumerState<PreferenceTestPage> {
  int _currentIndex = 0;
  final List<Map<String, String>> _answers = [];
  String? _selectedOption;

  Map<String, String> get _currentQuestion =>
      preferenceQuestions[_currentIndex];
  List<String> get _currentOptions => _currentQuestion['details']!.split(', ');

  void _onAnswerSelected(String selectedOption) {
    setState(() {
      _selectedOption = selectedOption;
    });
  }

  void _onNextPressed() {
    final selected = _selectedOption;
    if (selected == null) return;

    final answer = {
      'questionId': _currentQuestion['questionId']!,
      'question': _currentQuestion['question']!,
      'selectedOption': selected,
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

    _selectedOption = null;
    _nextQuestion();
  }

  void _nextQuestion() async {
    if (_currentIndex < preferenceQuestions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      if (!mounted) return;
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder:
              (_) => PreferenceLoadingPage(
                answers: _answers,
                onRestart: _restartTest,
              ),
        ),
      );
    }
  }

  void _restartTest() {
    ref.invalidate(preferenceTestViewModelProvider);
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => const PreferenceTestPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFinished = _currentIndex >= preferenceQuestions.length;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Text('성향 테스트', style: TextStyle(color: AppColors.grey[400])),
        backgroundColor: AppColors.primary[300],
        leading: GestureDetector(
          onTap: () {
            if (_currentIndex > 0) {
              setState(() {
                _currentIndex--;
                _selectedOption = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(CupertinoIcons.back, color: AppColors.grey[400]),
        ),
      ),
      child: SafeArea(
        child:
            isFinished
                ? ResultView(
                  onRestart: _restartTest,
                  showButtons: true,
                  testId: '',
                )
                : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 100),
                        children: [
                          PageIndicatorBar(currentIndex: _currentIndex),
                          QuestionCard(question: _currentQuestion['question']!),
                          QuestionListView(
                            options: _currentOptions,
                            selectedOption: _selectedOption,
                            onOptionSelected: _onAnswerSelected,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: NextButton(
                        onPressed: _onNextPressed,
                        enabled: _selectedOption != null,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
