import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class DistrictBoxItem extends StatelessWidget {
  const DistrictBoxItem({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.width,
    this.height = 80,
    super.key,
  });
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary[400]! : Colors.grey[200]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            fontSize: text == '세종특별자치시' ? 13 : 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary[400] : Colors.black,
          ),
        ),
      ),
    );
  }
}
