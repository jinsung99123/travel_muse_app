import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_page_menu.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_profile_screen.dart';
import 'package:travel_muse_app/views/widgets/custom_app_bar.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: '마이페이지'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyProfileScreen(),
              Container(height: 5, width: double.infinity, color: AppColors.grey[50]),
              MyPageMenu(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
