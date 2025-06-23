import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/widgets/account_info.dart';
import 'package:travel_muse_app/views/my_page/widgets/delete_account_button.dart';
import 'package:travel_muse_app/views/my_page/widgets/log_out_button.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_profile_screen.dart';
import 'package:travel_muse_app/views/my_page/widgets/user_info.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
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
      ),
    );
  }
}
