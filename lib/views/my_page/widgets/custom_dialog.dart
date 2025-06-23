import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '탈퇴하시겠습니까?',
            style: TextStyle(
              color: const Color(0xFF26272A),
              fontSize: 18,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '작성한 글, 댓글은 자동으로 삭제되지 않아요',
            style: TextStyle(
              color: const Color(0xFF646D71),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              optionButton(
                backgroundColor: AppColors.white,
                borderColor: AppColors.grey[300]!,
                textColor: AppColors.grey[700]!,
                text: '취소',
              ),
              SizedBox(width: 8),
              optionButton(
                backgroundColor: AppColors.primary[300]!,
                borderColor: Colors.transparent,
                textColor: AppColors.white,
                text: '확인',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded optionButton({
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required String text,
  }) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: borderColor,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}
