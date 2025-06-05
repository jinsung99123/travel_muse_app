import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/onboarding/widgets/next_button.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';

class OnboardingPageSetProfile extends StatelessWidget {
  const OnboardingPageSetProfile({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Text('프로필 사진', style: TextStyle(fontSize: 15)),
                  SizedBox(height: 20),
                  EditProfileImage(widgetSize: 100, iconSize: 50),
                  SizedBox(height: 20),
                  EditNickname(),
                ],
              ),
              Column(
                children: [
                  Spacer(),
                  NextButton(text: '다음'),
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
