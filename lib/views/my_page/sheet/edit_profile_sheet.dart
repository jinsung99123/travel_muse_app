import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/sheet/widgets/appbar_button.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 취소
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          '프로필 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // 완료, 제출
          AppbarButton(
            widget: const Text('완료', style: TextStyle(fontSize: 18)),
            onPressed: () {
              //
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            EditProfileImage(widgetSize: 120, iconSize: 40),
            const SizedBox(height: 20),
            // TODO: 텍스트 컨트롤러 관리 - 생성, 할당, dispose
            EditNickname(),
          ],
        ),
      ),
    );
  }
}
