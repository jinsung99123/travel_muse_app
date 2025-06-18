import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class PageIndicatorBar extends StatelessWidget {
  const PageIndicatorBar({
    super.key,
    required this.currentIndex,
    this.totalCount = 6,
  });
  final int currentIndex;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalCount,
          (index) => Container(
            width: 46,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color:
                  index == currentIndex
                      ? AppColors.primary[400]
                      : AppColors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
