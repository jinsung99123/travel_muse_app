import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';

class OnboardingTabNickname extends StatelessWidget {
  const OnboardingTabNickname({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
<<<<<<< HEAD
        const Text('닉네임을 입력해 주세요.', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        // TODO: 텍스트 컨트롤러 관리 - 생성, 할당, dispose
=======
        Text('닉네임을 입력해 주세요.', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
>>>>>>> 53b23cc (feat: 프로필 수정 위젯 온보딩 탭에 적용)
        EditNickname(),
      ],
    );
  }
}
