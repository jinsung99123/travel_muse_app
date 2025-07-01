import 'package:flutter/material.dart';

class VersionPage extends StatelessWidget {
  const VersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('버전 정보')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '앱 버전',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('현재 버전: v1.0.1 (Build 100)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text('개발사: Travel Muse Inc.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text(
              '© 2025 Travel Muse. All rights reserved.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
