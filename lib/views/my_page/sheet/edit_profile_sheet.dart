import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:travel_muse_app/views/my_page/sheet/widgets/appbar_button.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';
=======
>>>>>>> 2589835 (feat: 프로필 수정 시트 ui 구현)

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        // 취소
        leading: AppbarButton(
          widget: const Icon(Icons.close, size: 30),
          onPressed: () {},
=======
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.transparent,
          child: Icon(Icons.close),
>>>>>>> 2589835 (feat: 프로필 수정 시트 ui 구현)
        ),
        title: const Text(
          '프로필 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
<<<<<<< HEAD
          // 완료, 제출
          AppbarButton(
            widget: const Text('완료', style: TextStyle(fontSize: 18)),
            onPressed: () {
              //
            },
=======
          Container(
            width: 70,
            height: 50,
            color: Colors.transparent,
            child: Center(
              child: const Text('완료', style: TextStyle(fontSize: 16)),
            ),
>>>>>>> 2589835 (feat: 프로필 수정 시트 ui 구현)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
<<<<<<< HEAD
            const SizedBox(height: 20),
            EditProfileImage(widgetSize: 120, iconSize: 40),
            const SizedBox(height: 20),
            // TODO: 텍스트 컨트롤러 관리 - 생성, 할당, dispose
=======
            SizedBox(height: 20),
            EditProfileImage(),
            SizedBox(height: 20),
>>>>>>> 2589835 (feat: 프로필 수정 시트 ui 구현)
            EditNickname(),
          ],
        ),
      ),
    );
  }
}
<<<<<<< HEAD
=======

class EditNickname extends StatelessWidget {
  const EditNickname({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '닉네임',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            // 추후 유저 기존 닉네임 연결
            hintText: '기존 닉네임',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 이미지피커
      },
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              // 추후 파이어베이스 이미지 url연결
              child: Image.network(
                'https://picsum.photos/id/1/200/200',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[200],
                  border: Border.all(width: 1, color: Colors.grey[400]!),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[600],
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
>>>>>>> 2589835 (feat: 프로필 수정 시트 ui 구현)
