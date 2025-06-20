import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_profile_screen.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '계정 관리',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyProfileScreen(),

          ListTile(
            title: const Text(
              '생년월일',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('1990-01-01'),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              '성별',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('남성'),
            onTap: () {},
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('탈퇴하기'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
