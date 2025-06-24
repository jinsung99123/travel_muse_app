import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';

class UserNextButton extends StatelessWidget {
  const UserNextButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isActivated,
    required this.isUploading,
  });
  final String text;
  final VoidCallback onPressed;
  final bool isActivated;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: double.infinity,
          height: 56,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color:
                !isUploading
                    ? isActivated
                        ? AppColors.primary[300]
                        : AppColors.grey[50]
                    : AppColors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Center(
            child:
                !isUploading
                    ? Text(
                      text,
                      style:
                          isActivated
                              ? AppTextStyles.avaliableButtonText
                              : AppTextStyles.unavaliableButtonText,
                    )
                    : CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
          ),
        ),
      ),
    );
  }
}
