import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class ScheduleBottomButtons extends StatelessWidget {
  const ScheduleBottomButtons({super.key, required this.onEditTap});

  final VoidCallback onEditTap;

  static final blueGrad = LinearGradient(
    colors: [AppColors.primary[200]!,AppColors.primary[300]!],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: GestureDetector(
        onTap: onEditTap,
        child: Container(
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: blueGrad,
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
