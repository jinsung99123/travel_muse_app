import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/user/app_user_view_model_provider.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class PreferenceIntroPage2 extends ConsumerWidget {
  const PreferenceIntroPage2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUserState = ref.watch(appUserViewModelProvider);
    final nickname = appUserState.value?.nickname ?? '';

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  height: 154,
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nickname.isNotEmpty
                            ? 'Ai 기반 맞춤 추천을 위해\n$nickname님의 여행 성향을 알려주세요'
                            : 'Ai 기반 맞춤 추천을 위해\n여행 성향을 알려주세요',
                        style: const TextStyle(
                          color: Color(0xFF26272A),
                          fontSize: 24,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '6가지 질문에 대답해주신 대로\n여행성향 결과를 파악해서 추천해드릴게요!',
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
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/test_start.png',
                    width: 333,
                    height: 333,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: CupertinoButton(
                    color: const Color(0xFF48CDFD),
                    borderRadius: BorderRadius.circular(10),
                    child: const Text(
                      '시작하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const PreferenceTestPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
