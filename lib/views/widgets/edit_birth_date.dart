import 'package:flutter/material.dart';

class EditBirthDate extends StatelessWidget {
  const EditBirthDate({
    super.key,
    required this.formKey,
    required this.controller,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '생년월일',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Form(
              key: formKey,

              child: TextFormField(
                controller: controller,
                // validator: // 생년월일 validator
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  helper: Text(
                    '주민등록상 생년월일 8자리를 입력해주세요',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7C878C),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
