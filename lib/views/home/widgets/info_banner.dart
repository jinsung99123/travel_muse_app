import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '사용자님,\n도쿄 여행까지 3일 남았어요!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF26272A),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '6박 7일 | 6.4 (수) - 6.11 (수)',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7C878C),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: 상세보기 이동 로직 연결
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text(
              '자세히 보기',
              style: TextStyle(fontSize: 14, color: Color(0xFF98A0A4)),
            ),
          ),
        ],
      ),
    );
  }
}
