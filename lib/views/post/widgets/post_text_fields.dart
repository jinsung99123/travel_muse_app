import 'package:flutter/material.dart';

class PostTextFields extends StatelessWidget {
  const PostTextFields({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.onChanged,
  });
  final TextEditingController titleController;
  final TextEditingController contentController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 제목 입력
        TextField(
          controller: titleController,
          onChanged: (_) => onChanged(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1F20),
            fontFamily: 'Pretendard',
            height: 1.5,
          ),
          decoration: const InputDecoration(
            hintText: '제목을 입력해주세요',
            hintStyle: TextStyle(
              color: Color(0xFF646D71),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
              height: 1.5,
            ),
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 8),

        // 본문 입력
        TextField(
          controller: contentController,
          onChanged: (_) => onChanged(),
          maxLines: null,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1C1F20),
            fontFamily: 'Pretendard',
            height: 1.5,
          ),
          decoration: const InputDecoration(
            hintText: '내용을 입력해주세요',
            hintStyle: TextStyle(
              color: Color(0xFF98A0A4),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard',
              height: 1.5,
            ),
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
