import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';

class PostLoadingItem extends StatelessWidget {
  const PostLoadingItem({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth * 0.3,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.grey[100],
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: screenWidth * 0.55,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.grey[100],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.grey[100],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.grey[100],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.grey[100],
                  ),
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: AppColors.grey[100],
          ),
        ),
      ],
    );
  }
}
