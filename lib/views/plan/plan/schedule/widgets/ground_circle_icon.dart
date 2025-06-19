import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class GradientCircleIcon extends StatelessWidget {
  const GradientCircleIcon({
    super.key,
    this.size = 28,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient:  LinearGradient(
          begin: Alignment(-0.3, -1.0),           // 대각선 방향
          end: Alignment(0.0, 1.2),
          colors: [
            Colors.white,
            AppColors.primary[300]!,                    // 중간 밝은 파랑
            AppColors.primary[400]!,                    // 진한 파랑
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          //그림자
          BoxShadow(
           color: Color.fromRGBO(0, 0, 0, 0.03),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            offset: const Offset(0, 4),
            blurRadius: 1,
          ),
        ],
      ),
    );
  }
}
