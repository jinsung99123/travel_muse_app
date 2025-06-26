import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/home/home_place.dart';

class LocationRow extends StatelessWidget {
  const LocationRow({super.key, required this.place});

  final HomePlace place;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            place.address,
            style:  TextStyle(
              color: AppColors.grey[500],
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
