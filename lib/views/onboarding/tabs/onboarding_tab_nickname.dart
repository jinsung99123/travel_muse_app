import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';

class OnboardingTabNickname extends StatelessWidget {
  const OnboardingTabNickname({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('닉네임을 입력해 주세요.', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        // TODO: 텍스트 컨트롤러 관리 - 생성, 할당, dispose
        EditNickname(),
      ],
    );
  }
}
