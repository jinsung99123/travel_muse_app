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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '닉네임',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Form(
              key: formKey,
              child: SizedBox(
                height: 80,
                child: TextFormField(
                  controller: controller,
                  validator: Validators.validateNickname,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                    hintText: '닉네임', // TODO: 유저 기존 닉네임 연결, 없을 시 표시 X
                    // helper: Text(
                    //   '최대 8자까지 작성 가능합니다', // TODO : 유저 닉네임 validator 통과 시 표시 X
                    //   style: TextStyle(

                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //     color: Color(0xFF7C878C),
                    //   ),
                    // ),
                    // validator 반환 텍스트 스타일
                    errorStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.redAccent,
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
