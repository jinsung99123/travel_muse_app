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
    final screenWidth = MediaQuery.of(context).size.width;
    final totalSpacing = 6.5 * 2 * (totalCount - 1);
    final indicatorWidth = (screenWidth - totalSpacing - 48) / totalCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalCount,
          (index) => Container(
            width: indicatorWidth.clamp(24.0, 60.0),
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 6.5),
            decoration: BoxDecoration(
              color:
                  index == currentIndex
                      ? AppColors.secondary[200]
                      : AppColors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
