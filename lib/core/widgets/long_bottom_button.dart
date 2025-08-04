import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class LongBottomButton extends StatelessWidget {
  const LongBottomButton({
    super.key,
    required this.onEditTap,
    required this.buttonText,
    required this.backgroundColor,
    this.textColor = AppColors.white,
    this.visible = true,
    this.isFloating = false,
  });

  final VoidCallback onEditTap;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final bool visible;
  final bool isFloating;

   @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    if (isFloating) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: onEditTap,
            backgroundColor: backgroundColor,
            label: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
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
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: isFloating ? 18 : 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
      ),
    );
  }
}
