import 'package:flutter/material.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            MyProfileScreen(),
            const SizedBox(height: 25),
            Container(
              height: 3,
              width: double.infinity,
              color: Colors.grey[200],
            ),
            MyPageMenu(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
