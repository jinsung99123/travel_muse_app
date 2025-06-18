import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class ConfirmAddButton extends StatelessWidget {
  const ConfirmAddButton({super.key, required this.visible, this.onTap});
  final bool visible;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '추가하기',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
      ),
    );
  }
}
