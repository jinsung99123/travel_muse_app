import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/viewmodels/preference/preference_test_view_model.dart';
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

  /// 보기 선택 시 실행되는 콜백
  void _onAnswerSelected(String selectedOption) {
    setState(() {
      _selectedOption = selectedOption;
    });
  }

  /// "다음" 버튼을 눌렀을 때의 처리
  void _onNextPressed() {
    final viewModel = PreferenceTestViewModel(ref);
    final selected = _selectedOption;
    if (selected == null) return;

    final currentQuestion = viewModel.getCurrentQuestion(_currentIndex);
    viewModel.saveAnswer(
      answers: _answers,
      question: currentQuestion,
      selectedOption: selected,
    );

    _selectedOption = null;
    _goToNext();
  }

  /// 다음 질문 또는 결과 페이지로 이동
  void _goToNext() {
    final viewModel = PreferenceTestViewModel(ref);
    viewModel.goToNext(
      context: context,
      currentIndex: _currentIndex,
      answers: _answers,
      onRestart: _restartTest,
      incrementIndex: () {
        setState(() {
          _currentIndex++;
        });
      },
    );
  }

  /// 테스트 다시 시작 시 호출
  void _restartTest() {
    final viewModel = PreferenceTestViewModel(ref);
    viewModel.restartTest(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = PreferenceTestViewModel(ref);
    final currentQuestion = viewModel.getCurrentQuestion(_currentIndex);
    final currentOptions = viewModel.getOptions(currentQuestion);
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
                          QuestionCard(question: currentQuestion['question']!),
                          QuestionListView(
                            options: currentOptions,
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
