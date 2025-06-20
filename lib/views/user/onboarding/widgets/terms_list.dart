import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/views/user/onboarding/terms_detail_bottom_sheet.dart';
import 'package:travel_muse_app/views/user/onboarding/widgets/custom_check_toggle.dart';

class TermsList extends StatelessWidget {
  const TermsList({super.key, required this.termsKeys});

  final List<String> termsKeys;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: termsKeys.length - 1,
        itemBuilder:
            (context, index) => SizedBox(
              width: double.maxFinite,
              child: Row(
                children: [
                  CustomCheckToggle(index: index + 1),
                  SizedBox(width: 12),
                  Text(termsKeys[index + 1], style: AppTextStyles.termsText),
                  Spacer(),
                  showDetailTextButton(context: context),
                ],
              ),
            ),
        separatorBuilder: (context, index) => SizedBox(height: 12),
      ),
    );
  }

  GestureDetector showDetailTextButton({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const TermsDetailBottomSheet();
          },
        );
      },
      child: Text(
        '보기',
        style: TextStyle(
          color: AppColors.grey[300],
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
