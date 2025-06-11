import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/viewmodels/edit_birth_date_view_model.dart';
import 'package:travel_muse_app/viewmodels/edit_nickname_view_model.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/views/onboarding/terms_agreement_bottom_sheet.dart';
import 'package:travel_muse_app/views/onboarding/widgets/next_button.dart';
import 'package:travel_muse_app/views/onboarding/widgets/select_gender.dart';
import 'package:travel_muse_app/views/preference/preference_intro_page_2.dart';
import 'package:travel_muse_app/views/onboarding/widgets/edit_birth_date.dart';
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
    final birthDateState = ref.watch(editBirthDateViewModelProvider);

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
                      // TODO: 조건 만족하지 않는 경우 아예 비활성화되게 변경
                      log('다음 버튼 누름');
                      // // 닉네임뷰모델 조건
                      // final isNicknameChecked =
                      //     nicknameViewmodel.isCheckedDuplication();

                      // // 생년월일 뷰모델 조건
                      // birthDateViewmodel.validate(birthDateController.text);

                      // // 성별선택박스 조건
                      // profileViewmodel.isGenderValid();

                      // if (!isNicknameChecked) return;
                      // if (birthDateState.isValid != true) return;
                      // if (profileState.isGenderValid != true) return;

                      // log('조건 통과');

                      // // 조건 통과 시에만 메서드 실행
                      // await profileViewmodel.updateProfile(
                      //   nicknameController.text,
                      //   birthDateController.text,
                      // );

                      await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const TermsAgreementBottomSheet();
                        },
                      );
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
