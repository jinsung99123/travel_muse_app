import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({
    super.key,
    required this.isEditing,
    required this.onToggleEdit,
  });

  final bool isEditing;
  final Future<void> Function()? onToggleEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            '여행 일정을 등록해주세요',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(32, 27),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onToggleEdit ?? () {},
            child: Text(
              isEditing ? '완료' : '편집',
              style: TextStyle(
                color: AppColors.primary[500],
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}