import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
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
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            MyProfileScreen(),
            Container(
              height: 5,
              width: double.infinity,
              color: AppColors.grey[50],
            ),
            MyPageMenu(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
