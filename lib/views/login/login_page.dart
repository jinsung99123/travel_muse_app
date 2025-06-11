import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/viewmodels/auth_view_model.dart';
import 'package:travel_muse_app/views/login/widgets/sns_login_bar.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewmodel = ref.read(authViewModelProvider.notifier);
    final double iconSize = 24;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: 13),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('TravelMuse', style: AppTextStyles.appTitle),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('환영합니다', style: AppTextStyles.appSubTitle),
                ),
              ],
            ),
            Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  SnsLoginBar(
                    sns: 'Google',
                    backgroundColor: AppColors.white,
                    textColor: AppColors.black,
                    imageWidget: Image.asset(
                      'assets/sns_icons/google.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                    loginFunction:
                        () => viewmodel.loginWithGoogle(), // SignWithGoogle
                  ),
                  SizedBox(height: 12),
                  SnsLoginBar(
                    sns: 'Apple',
                    backgroundColor: AppColors.black,
                    textColor: AppColors.white,
                    imageWidget: SvgPicture.asset(
                      'assets/sns_icons/apple.svg',
                      width: iconSize,
                      height: iconSize,
                    ),
                    loginFunction:
                        () => viewmodel.loginWithGoogle(), // TODO: 애플로그인으로 변경
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
