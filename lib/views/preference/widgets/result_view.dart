import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/providers/preference/preference_test_provider.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/views/preference/widgets/result_action_buttons.dart';
import 'package:travel_muse_app/views/preference/widgets/result_view_detail.dart';

class ResultView extends ConsumerStatefulWidget {
  const ResultView({
    super.key,
    required this.onRestart,
    required this.showButtons,
    required this.testId,
  });

  final VoidCallback onRestart;
  final bool showButtons;
  final String testId;

  @override
  ConsumerState<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends ConsumerState<ResultView> {
  final Map<String, String> resultImageMap = {
    '계획러': 'assets/images/result_planner.jpg',
    '자유인': 'assets/images/result_free_spirit.jpg',
    '자연인': 'assets/images/result_nature_lover.jpg',
    '도시러': 'assets/images/result_city_explorer.jpg',
    '균형러': 'assets/images/result_balanced_traveler.jpg',
    '모험가': 'assets/images/result_experience_seeker.jpg',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.testId != '') {
        ref
            .read(preferenceTestStateNotifierProvider.notifier)
            .loadTest(widget.testId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preferenceTestStateNotifierProvider);
    final result = state.value?.result;
    final profileState = ref.watch(profileViewModelProvider);
    final nickname = profileState.currentNickname;
    if (nickname == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final typeCode = result?['type'];
    final description = result?['details'];
    final imagePath = resultImageMap[typeCode] ?? '';

    if (state.isLoading || typeCode == null || description == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar:
          !widget.showButtons
              ? AppBar(
                title: const Text('나의 여행 성향'),
                actions: [
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'delete') {
                        final confirm = await showCupertinoModalPopup<bool>(
                          context: context,
                          builder:
                              (_) => CupertinoActionSheet(
                                title: const Text('성향 테스트 삭제'),
                                message: const Text('이 테스트 결과를 삭제하시겠어요?'),
                                actions: [
                                  CupertinoActionSheetAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('삭제하기'),
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text('취소'),
                                ),
                              ),
                        );

                        if (confirm == true) {
                          await ref
                              .read(
                                preferenceTestStateNotifierProvider.notifier,
                              )
                              .deleteTest(widget.testId);
                          if (context.mounted) {
                            /// 리스트 Provider invalidate
                            ref.invalidate(preferenceTestListProvider);

                            /// 단건 상태 초기화
                            ref.invalidate(preferenceTestStateNotifierProvider);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('성향 테스트가 삭제되었습니다')),
                            );

                            Navigator.pop(context, 'deleted');
                          }
                        }
                      }
                    },
                    itemBuilder:
                        (_) => [
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(
                              '삭제',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                  ),
                ],
              )
              : null,
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nickname님의 여행 성향은 \n$typeCode예요!',
                      style: AppTextStyles.onboardingTitle.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$nickname님의 여행 성향은 마이페이지에서 \n언제든지 확인할 수 있어요',
                      style: AppTextStyles.onboardingSubTitle,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Container(
                      width: 198,
                      height: 198,
                      color: AppColors.white,
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
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.preferenceDescriptionText,
                ),
              ),
              SizedBox(height: 10),
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
                  children: [
                    Text('선택지 보기', style: AppTextStyles.helperText),
                    const SizedBox(width: 4),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: 16,
                      color: AppColors.grey[400],
                    ),
                  ],
                ),
              ),
            ],
          ),
          widget.showButtons
              ? Column(
                children: [
                  Spacer(),

                  ResultActionButtons(onRestart: widget.onRestart),
                  const SizedBox(height: 34),
                ],
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
