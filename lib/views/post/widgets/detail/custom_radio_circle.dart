import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class CustomRadioCircle extends StatelessWidget {
  const CustomRadioCircle({super.key, required this.selected});
  final bool selected;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary[400] :  AppColors.grey[100],
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
