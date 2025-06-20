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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), // 양쪽 padding
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FloatingActionButton.extended(
          onPressed: onTap,
          backgroundColor: AppColors.primary[300],
          label: const Text(
            '추가하기',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
