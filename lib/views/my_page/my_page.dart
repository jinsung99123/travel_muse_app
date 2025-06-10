import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_page_menu.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_profile_screen.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MyProfileScreen(),
            const SizedBox(height: 30),
            MyPageMenu(),
          ],
        ),
      ),
    );
  }
}
