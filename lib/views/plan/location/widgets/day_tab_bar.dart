import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class DayTabBar extends StatelessWidget {
  const DayTabBar({
    required this.controller,
    required this.days,
    super.key,
  });

  final TabController controller;
  final List<String> days;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey[50]!, width: 0.5)),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,                 // Day 10~ 스크롤
        tabAlignment: TabAlignment.center, 
        labelColor: Colors.black,
        unselectedLabelColor: AppColors.grey[300],
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 17),
        indicatorColor: AppColors.primary[400],
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        tabs: days.map((d) => Tab(text: d)).toList(),
      ),
    );
  }
}
