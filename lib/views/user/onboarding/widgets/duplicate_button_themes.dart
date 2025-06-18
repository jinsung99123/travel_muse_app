import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';

class DuplicateButtonThemes {
  static ShapeDecoration unavailableBoxStyle = ShapeDecoration(
    color: AppColors.grey[50],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static ShapeDecoration availableBoxStyle = ShapeDecoration(
    color: AppColors.primary[300],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static ShapeDecoration alreadyCheckedBoxStyle = ShapeDecoration(
    color: AppColors.primary[50],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static Text unavailableText = Text(
    '중복 확인',
    style: AppTextStyles.unavaliableButtonText,
  );

  static Text availableText = Text(
    '중복 확인',
    style: AppTextStyles.avaliableButtonText,
  );

  static Text alreadyCheckedText = Text(
    '확인 완료',
    style: AppTextStyles.alreadyCheckedButtonText,
  );

  ShapeDecoration getButtonStyle(String buttonState) {
    ShapeDecoration result = unavailableBoxStyle;
    if (buttonState == '확인 불가') {
      result = unavailableBoxStyle;
    } else if (buttonState == '확인 필요') {
      result = availableBoxStyle;
    } else if (buttonState == '확인 완료') {
      result = alreadyCheckedBoxStyle;
    }
    return result;
  }

  Text getText(String buttonState) {
    Text result = unavailableText;
    if (buttonState == '확인 불가') {
      result = unavailableText;
    } else if (buttonState == '확인 필요') {
      result = availableText;
    } else if (buttonState == '확인 완료') {
      result = alreadyCheckedText;
    }
    return result;
  }
}
