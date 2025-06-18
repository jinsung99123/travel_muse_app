import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';

class TermsAgreementTitle extends StatelessWidget {
  const TermsAgreementTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('약관에 동의해주세요', style: AppTextStyles.onboardingTitle),
          SizedBox(height: 8),
          Text(
            '여러분의 개인정보와 서비스 이용 권리\n잘 지켜드릴게요',
            style: AppTextStyles.onboardingSubTitle,
          ),
        ],
      ),
    );
  }
}
