import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class RegionRecommendHeader extends StatelessWidget {
  const RegionRecommendHeader({super.key, required this.region});
  final String region;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10),
      child: Row(
        children: [
           Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
            child: Icon(
              Icons.location_on,
              size: 24,
              color: AppColors.primary[400],
            ),
          ),
          Text(
            '$region 지역 추천 장소',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }
}
