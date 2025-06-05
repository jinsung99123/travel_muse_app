import 'package:flutter/material.dart';
import 'package:travel_muse_app/core/validators.dart';

class EditNickname extends StatelessWidget {
  const EditNickname({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              '닉네임',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: 10),
        Form(
          key: formKey,

          child: TextFormField(
            controller: controller,
            validator: Validators.validateNickname,
            decoration: InputDecoration(
              hintText: '닉네임', // 추후 유저 기존 닉네임 연결
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
