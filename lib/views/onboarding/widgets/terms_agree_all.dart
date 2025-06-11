import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/views/onboarding/widgets/custom_check_toggle.dart';

class TermsAgreeAll extends StatelessWidget {
  const TermsAgreeAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          CustomCheckToggle(index: 0),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '모두 동의',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
              Text(
                '서비스 이용을 위해 아래 약관에 모두 동의합니다',
                style: AppTextStyles.helperText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
