import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/views/onboarding/widgets/next_button.dart';
import 'package:travel_muse_app/views/onboarding/widgets/select_gender.dart';
import 'package:travel_muse_app/views/widgets/edit_birth_date.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';

class OnboardingPageSetProfile extends ConsumerWidget {
  const OnboardingPageSetProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileViewmodel = ref.read(profileViewModelProvider.notifier);
    final profileState = ref.watch(profileViewModelProvider);

    final nicknameController = profileViewmodel.nicknameController;
    final birthDateController = profileViewmodel.birthDateController;
    final formKeyNickname = profileViewmodel.formKeyNickname;
    final formKeyBirthDate = profileViewmodel.formKeyBirthDate;
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  EditProfileImage(size: 88),
                  EditNickname(
                    formKey: formKeyNickname,
                    controller: nicknameController,
                  ),
                  EditBirthDate(
                    formKey: formKeyBirthDate,
                    controller: birthDateController,
                  ),
                  SelectGender(),
                ],
              ),
              Column(
                children: [
                  Spacer(),
                  NextButton(
                    text: '다음',
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await profileViewmodel.updateNickname();
                      if (profileState.temporaryImageUrl != null) {
                        await profileViewmodel.updateProfileImage(
                          profileState.temporaryImageUrl!,
                        );
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
