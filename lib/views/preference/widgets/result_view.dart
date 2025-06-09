import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/preference_test_provider.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';
import 'package:travel_muse_app/views/preference/widgets/preference_questions.dart';
import 'package:travel_muse_app/views/preference/widgets/result_action_buttons.dart';
import 'package:travel_muse_app/views/preference/widgets/result_view_detail.dart';

class ResultView extends ConsumerStatefulWidget {
  const ResultView({super.key, required this.onRestart});

  final VoidCallback onRestart;

  @override
  ConsumerState<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends ConsumerState<ResultView> {
  final Map<String, String> resultImageMap = {
    'planner': 'assets/images/result_planner.jpg',
    'free_spirit': 'assets/images/result_free_spirit.jpg',
    'nature_lover': 'assets/images/result_nature_lover.jpg',
    'city_explorer': 'assets/images/result_city_explorer.jpg',
    'balanced_traveler': 'assets/images/result_balanced_traveler.jpg',
    'experience_seeker': 'assets/images/result_experience_seeker.jpg',
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preferenceTestViewModelProvider);
    final answers = state.value?.answers ?? [];
    final result = state.value?.result;
    final typeCode = result?['type'];
    final description = result?['details'];
    final imagePath = resultImageMap[typeCode] ?? '';

    final Map<String, String> referenceQuestionTexts = {
      for (final q in preferenceQuestions) q['questionId']!: q['question']!,
    };

    if (state.isLoading || typeCode == null || description == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '사용자님의 여행 성향은 \n$typeCode예요!',
                      style: const TextStyle(
                        color: Color(0xFF26272A),
                        fontSize: 24,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '사용자님의 여행 성향은 마이페이지에서 \n언제든지 변경할 수 있어요',
                      style: TextStyle(
                        color: Color(0xFF7C878C),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ClipOval(
                child: Container(
                  width: 198,
                  height: 198,
                  color: const Color(0xFFE0F6FE),
                  child:
                      imagePath.isNotEmpty
                          ? Image.asset(imagePath, fit: BoxFit.cover)
                          : const Icon(
                            CupertinoIcons.exclamationmark_triangle,
                            size: 48,
                            color: Colors.red,
                          ),
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4C5356),
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const ResultViewDetail(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '선택지 보기',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFCED2D3),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: 16,
                      color: Color(0xFFCED2D3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ResultActionButtons(onRestart: widget.onRestart),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
