import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class ProvinceBoxItem extends StatelessWidget {
  const ProvinceBoxItem({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary[400]! : Colors.grey[200]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary[400] : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
