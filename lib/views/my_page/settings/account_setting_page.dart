import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/user/auth_view_model_provider.dart';
import 'package:travel_muse_app/views/my_page/widgets/account_info.dart';
import 'package:travel_muse_app/views/my_page/widgets/confirm_dialog.dart';
import 'package:travel_muse_app/views/my_page/widgets/my_profile_screen.dart';
import 'package:travel_muse_app/views/user/login/login_page.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class AccountSettingPage extends ConsumerStatefulWidget {
  const AccountSettingPage({super.key});

  @override
  ConsumerState<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends ConsumerState<AccountSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 관리'),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: MyProfileScreen()),
          Container(
            width: double.infinity,
            height: 5,
            decoration: BoxDecoration(color: AppColors.grey[50]),
          ),
          AccountInfo(),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _logOut(context, ref);
                },
                child: bottomTextButton('로그아웃'),
              ),
              SizedBox(
                height: 14,
                child: VerticalDivider(
                  width: 14,
                  color: AppColors.grey[600],
                  thickness: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showConfirmDialog(ref);
                },
                child: bottomTextButton('회원탈퇴'),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  Widget bottomTextButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.grey[600],
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ),
    );
  }

  void _logOut(BuildContext context, WidgetRef ref) {
    ref.read(authViewModelProvider.notifier).logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  Future<void> _showConfirmDialog(WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => const ConfirmDialog(
            title: '탈퇴하시겠습니까?',
            description: '작성한 글, 댓글은 자동으로 삭제되지 않아요',
          ),
    );

    if (!mounted) return;

    if (result == true) {
      await ref.read(authViewModelProvider.notifier).deleteAccount();

      if (!mounted) return;

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }
}
