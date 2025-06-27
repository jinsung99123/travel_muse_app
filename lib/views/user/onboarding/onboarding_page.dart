import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/views/user/onboarding/terms_agreement_bottom_sheet.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';
import 'package:travel_muse_app/views/widgets/user_next_button.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);

    bool canUpdate = profileState.canUpdateProfile;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text(
                      '회원 정보를 입력해 주세요',
                      style: AppTextStyles.onboardingTitle,
                    ),
                  ),
                  EditProfileImage(),
                  EditNickname(),
                ],
              ),
              Column(
                children: [
                  Spacer(),
                  UserNextButton(
                    text: '다음',
                    isActivated: canUpdate,
                    isUploading: false,
                    onPressed: () {
                      if (canUpdate) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!context.mounted) return;
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => const TermsAgreementBottomSheet(),
                          );
                        });
                      }
                    },
                  ),
                  SizedBox(height: 34),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
