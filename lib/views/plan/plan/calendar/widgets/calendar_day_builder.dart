import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

Widget buildDayCell(DateTime day, bool isInRange, bool selected) {
  final bool isToday = DateUtils.isSameDay(day, DateTime.now());
  final bool isCircle = selected || isInRange;

  return Container(
    margin: const EdgeInsets.all(4.0),
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color:
          selected
              ? AppColors.primary[300]
              : isInRange
              ? AppColors.primary[50]
              : null,
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: isCircle ? null : BorderRadius.circular(8.0),
    ),
    child: Center(
      child: Text(
        '${day.day}',
        style: TextStyle(
          fontSize: 20,
          color:
              selected
                  ? Colors.white
                  : isInRange
                  ? AppColors.primary[300]
                  : isToday
                  ? AppColors.secondary[400]
                  : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
