import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class AppTextStyles {
  // 앱 타이틀
  static const TextStyle appTitle = TextStyle(
    color: AppColors.black,
    fontSize: 36,
    fontFamily: 'Ssangmun',
    fontWeight: FontWeight.w700,
  );

  // 앱 서브타이틀
  static const TextStyle appSubTitle = TextStyle(
    color: AppColors.black,
    fontSize: 20,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
  );

  // 온보딩 타이틀
  static const TextStyle onboardingTitle = TextStyle(
    color: AppColors.black,
    fontSize: 24,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  // 온보딩 부제
  static TextStyle onboardingSubTitle = TextStyle(
    color: AppColors.grey[400],
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // 온보딩 각 세션 타이틀
  static const TextStyle onboardingSectionTitle = TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
  );

  // 텍스트폼필드 헬퍼텍스트
  static TextStyle helperText = TextStyle(
    color: AppColors.grey[400],
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // 텍스트폼필드 에러텍스트
  static const TextStyle errorText = TextStyle(
    color: AppColors.error,
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
  );

  // 버튼 활성화 텍스트
  static const TextStyle avaliableButtonText = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // 버튼 비활성화 텍스트
  static TextStyle unavaliableButtonText = TextStyle(
    color: AppColors.grey[200],
    fontSize: 18,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );

  // 온보딩 젠더박스 선택 텍스트
  static TextStyle selectedBoxText = TextStyle(
    color: AppColors.primary[500],
    fontSize: 18,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );

  // 온보딩 젠더박스 미선택 텍스트
  static TextStyle unselectedBoxText = TextStyle(
    color: AppColors.grey[200],
    fontSize: 18,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );

  // 약관 텍스트
  static TextStyle termsText = TextStyle(
    color: AppColors.black,
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    height: 1.50,
  );
}
