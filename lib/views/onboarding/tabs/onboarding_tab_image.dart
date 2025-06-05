import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';

class OnboardingTabImage extends StatelessWidget {
  const OnboardingTabImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('프로필 사진을 설정해 주세요.', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        EditProfileImage(size: 40),
      ],
    );
  }
}
