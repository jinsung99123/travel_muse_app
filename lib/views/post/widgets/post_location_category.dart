import 'package:flutter/material.dart';

class PostLocationCategory extends StatelessWidget {
  const PostLocationCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 위치 추가하기
        GestureDetector(
          onTap: () {
            // 위치 추가 동작
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.location_on_outlined,
                      size: 24,
                      color: Color(0xFF7C878C),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '위치 추가하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7C878C),
                        fontFamily: 'Pretendard',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF7C878C)),
              ],
            ),
          ),
        ),

        // 카테고리 추가하기
        GestureDetector(
          onTap: () {
            // 카테고리 추가 동작
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.tag, size: 24, color: Color(0xFF7C878C)),
                    SizedBox(width: 8),
                    Text(
                      '카테고리 추가하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7C878C),
                        fontFamily: 'Pretendard',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF7C878C)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
