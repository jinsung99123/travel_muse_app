import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('고객 지원')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '문의사항이 있으신가요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '앱 사용 중 불편한 점이나 궁금한 점이 있으시면 아래 이메일로 연락해 주세요.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '이메일: felixson99@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 40),
            Text(
              '운영시간: 평일 오전 10시 ~ 오후 6시\n주말 및 공휴일 제외',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
