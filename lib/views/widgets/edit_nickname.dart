import 'package:flutter/material.dart';
import 'package:travel_muse_app/core/validators.dart';

class EditNickname extends StatefulWidget {
  const EditNickname({super.key});

  @override
  State<EditNickname> createState() => _EditNicknameState();
}

class _EditNicknameState extends State<EditNickname> {
  final nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

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
          key: _formKey,
          child: TextFormField(
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
