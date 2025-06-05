import 'package:flutter/material.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/views/onboarding/widgets/next_button.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';

class OnboardingPageSetProfile extends StatelessWidget {
  OnboardingPageSetProfile({super.key});

  final profileViewmodel = ProfileViewModel();

  @override
  Widget build(BuildContext context) {
    final nicknameController = profileViewmodel.nicknameController;
    final formKey = profileViewmodel.formKey;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('회원 정보를 입력해 주세요')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              ListView(
                children: [
                  const Text('프로필 사진', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  EditProfileImage(size: 120),
                  SizedBox(height: 20),
                  EditNickname(
                    formKey: formKey,
                    controller: nicknameController,
                  ),
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
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
