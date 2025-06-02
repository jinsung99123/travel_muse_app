import 'package:flutter/material.dart';

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
