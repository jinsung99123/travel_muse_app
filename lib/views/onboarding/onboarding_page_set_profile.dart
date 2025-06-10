import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/edit_birth_date_view_model.dart';
import 'package:travel_muse_app/viewmodels/edit_nickname_view_model.dart';
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

    final nicknameViewmodel = ref.read(editNicknameViewModelProvider.notifier);
    final nicknameController = nicknameViewmodel.nicknameController;

    final birthDateViewmodel = ref.read(
      editBirthDateViewModelProvider.notifier,
    );
    final birthDateController = birthDateViewmodel.birthDateController;

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
                  EditNickname(controller: nicknameController),
                  EditBirthDate(controller: birthDateController),
                  SelectGender(),
                ],
              ),
              Column(
                children: [
                  Spacer(),
                  NextButton(
                    text: '다음',
                    onPressed: () async {
                      // TODO: 뷰모델에 메서드 만들어 대체
                      FocusScope.of(context).unfocus();
                      if (profileState.temporaryImagePath != null) {
                        await profileViewmodel.updateProfileImage();
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
