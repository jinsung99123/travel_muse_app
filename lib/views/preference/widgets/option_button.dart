import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final String title = text.split(',').first;
    final String subtitle =
        text.split(',').length > 1 ? text.split(',')[1].trim() : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    isSelected ? AppColors.primary[300]! : AppColors.grey[100]!,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected
                            ? AppColors.primary[300]
                            : AppColors.grey[500],
                    fontFamily: 'Pretendard',
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey[400],
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
