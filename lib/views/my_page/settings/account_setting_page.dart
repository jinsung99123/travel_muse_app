import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/widgets/account_info.dart';
import 'package:travel_muse_app/views/my_page/widgets/delete_account_button.dart';
import 'package:travel_muse_app/views/my_page/widgets/log_out_button.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_profile_screen.dart';
import 'package:travel_muse_app/views/my_page/widgets/user_info.dart';

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
          Center(child: MyProfileScreen()),
          Divider(),
          AccountInfo(),
          Divider(),
          UserInfo(),
          LogOutButton(),
          DeleteAccountButton(),
        ],
      ),
    );
  }
}
