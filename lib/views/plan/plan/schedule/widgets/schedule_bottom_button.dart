import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class ScheduleBottomButtons extends StatelessWidget {
  const ScheduleBottomButtons({super.key, required this.onEditTap});

  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, 
  width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: GestureDetector(
        onTap: onEditTap,
        child: Container(
          height: 56,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child:  Text(
            '일정 저장하기',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
      ),
    );
  }
}
