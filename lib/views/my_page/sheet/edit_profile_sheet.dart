import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/sheet/widgets/appbar_button.dart';
import 'package:travel_muse_app/views/my_page/sheet/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/my_page/sheet/widgets/edit_profile_image.dart';

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        // 취소
        leading: AppbarButton(
          widget: Icon(Icons.close, size: 30),
          onPressed: () {},
        ),
        title: const Text(
          '프로필 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // 완료, 제출
          AppbarButton(
            widget: Text('완료', style: TextStyle(fontSize: 18)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            EditProfileImage(),
            SizedBox(height: 20),
            EditNickname(),
          ],
        ),
      ),
    );
  }
}
