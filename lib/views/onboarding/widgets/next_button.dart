import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isActivated,
  });
  final String text;
  final VoidCallback onPressed;
  final bool isActivated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          //
          onPressed();
        },
        child: Container(
          width: double.infinity,
          height: 56,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: AppColors.primary[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Center(
            child: Text(text, style: AppTextStyles.avaliableButtonText),
          ),
        ),
      ),
    );
  }
}
