import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/views/my_page/settings/setting_page.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_page_menu.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_profile_screen.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '마이페이지',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyProfileScreen(),
              Container(
                height: 5,
                width: double.infinity,
                color: AppColors.grey[50],
              ),
              const MyPageMenu(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
