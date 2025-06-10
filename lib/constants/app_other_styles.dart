import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class AppOtherStyles {
  // 텍스트폼필드 enabledBorder
  static final unfocusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.grey[300]!, width: 1),
    borderRadius: BorderRadius.circular(10),
  );

  // 텍스트폼필드 focusedBorder
  static final focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.primary[300]!, width: 1.5),
    borderRadius: BorderRadius.circular(10),
  );

  // 온보딩 selectGender unselected
  static final unselectedBox = BoxDecoration(
    border: Border.all(
      width: 1,
      strokeAlign: BorderSide.strokeAlignOutside,
      color: AppColors.grey[300]!,
    ),
    borderRadius: BorderRadius.circular(10),
  );

  // 온보딩 selectGender selected
  static final selectedBox = BoxDecoration(
    border: Border.all(
      width: 1,
      strokeAlign: BorderSide.strokeAlignOutside,
      color: AppColors.primary[400]!,
    ),
    borderRadius: BorderRadius.circular(10),
  );
}
