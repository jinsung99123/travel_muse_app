import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

const double bulletSize = 24;

class Bullet extends StatelessWidget {
  const Bullet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: bulletSize,
      height: bulletSize,
      decoration:  BoxDecoration(
        color: AppColors.secondary[100], 
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: bulletSize * 0.55,        
          height: bulletSize * 0.55,
          decoration:  BoxDecoration(
            color: AppColors.secondary[200], 
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
