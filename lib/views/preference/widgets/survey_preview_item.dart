import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class SurveyPreviewItem extends StatelessWidget {
  const SurveyPreviewItem({
    super.key,
    required this.number,
    required this.title,
  });
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.secondary[50],
              borderRadius: BorderRadius.circular(500),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: AppColors.secondary[300],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
