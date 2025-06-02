import 'package:flutter/material.dart';

class EditNickname extends StatelessWidget {
  const EditNickname({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
<<<<<<< HEAD
            const Text(
=======
            Text(
>>>>>>> 53b23cc (feat: 프로필 수정 위젯 온보딩 탭에 적용)
              '닉네임',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            hintText: '닉네임', // 추후 유저 기존 닉네임 연결
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
