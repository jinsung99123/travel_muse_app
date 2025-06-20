import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/utills/distance_sort.dart';

class DistanceSortButton extends StatelessWidget {
  const DistanceSortButton({
    super.key,
    required this.daySchedules,
    required this.onResult,
  });

  final Map<int, List<Map<String, String>>> daySchedules;
  final void Function(Map<int, List<Map<String, String>>>) onResult;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final sorted = <int, List<Map<String, String>>>{};

        for (final entry in daySchedules.entries) {
          final day = entry.key;
          final places = entry.value;

          final canSort = places.every(
            (p) => p['lat'] != null && p['lng'] != null,
          );

          if (canSort) {
            try {
              final sortedPlaces = sortPlacesByDistance(places);
              sorted[day] = sortedPlaces;
            } catch (e) {
              sorted[day] = places;
            }
          } else {
            sorted[day] = places;
          }
        }

        onResult(sorted);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary[50]!,
              AppColors.primary[300]!,
              AppColors.primary[400]!,
            ],
            stops: const [0.0, 0.3, 0.7],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.sort, size: 20, color: AppColors.white),
            SizedBox(width: 5),
            Text(
              '거리순 정렬',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
