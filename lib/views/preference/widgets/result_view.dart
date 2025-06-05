import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_muse_app/providers/preference_test_provider.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class ResultView extends ConsumerStatefulWidget {
  const ResultView({super.key, required this.answers, required this.onRestart});

  final List<Map<String, String>> answers;
  final VoidCallback onRestart;

  @override
  ConsumerState<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends ConsumerState<ResultView> {
  bool _hasRequestedAI = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasRequestedAI) {
      _hasRequestedAI = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(preferenceTestViewModelProvider.notifier)
            .classifyTestOnly(widget.answers);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preferenceTestViewModelProvider);

    final result = state.value?.result;
    final typeCode = result?['type'];
    final description = result?['details'];

    if (state.isLoading || typeCode == null || description == null) {
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
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.answers.length,
            itemBuilder: (context, index) {
              final answer = widget.answers[index];
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
          child: Column(
            children: [
              CupertinoButton(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(12),
                onPressed: widget.onRestart,
                child: const Text(
                  '처음으로',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                color: CupertinoColors.activeGreen,
                borderRadius: BorderRadius.circular(12),
                onPressed: () async {
                  try {
                    await ref
                        .read(preferenceTestViewModelProvider.notifier)
                        .saveTestToFirestore();

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const HomePage(), // 여기에 이동할 페이지 지정
                        ),
                      );
                    }
                  } catch (e) {
                    showCupertinoDialog(
                      context: context,
                      builder:
                          (context) => CupertinoAlertDialog(
                            title: const Text('저장 오류'),
                            content: Text('저장 중 문제가 발생했습니다.\n$e'),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('확인'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                    );
                  }
                },
                child: const Text('완료', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
