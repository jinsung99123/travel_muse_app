import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/preference/preference_intro_page_2.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: CupertinoButton(
          color: AppColors.primary[400],
          borderRadius: BorderRadius.circular(10),
          child: const Text(
            '시작하기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const PreferenceIntroPage2(),
              ),
            );
          },
        ),
      ),
    );
  }
}
