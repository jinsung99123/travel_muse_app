import 'package:flutter/material.dart';

class SelectGender extends StatelessWidget {
  const SelectGender({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '성별',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Row(children: [optionBox('남성'), SizedBox(width: 16), optionBox('여성')]),
      ],
    );
  }

  Expanded optionBox(String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // 뷰모델메서드 - 선택 시 박스데코 변경, state 변경
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0xFF98A0A4),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF7C878C),
                fontSize: 18,
                fontFamily: 'Pretendard',
                height: 0.08,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
