import 'package:flutter/material.dart';

class DayTabBar extends StatelessWidget {
  const DayTabBar({required this.controller, required this.days, super.key});
  
  final TabController controller;
  final List<String> days;


  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      tabs: days.map((d) => Tab(text: d)).toList(),
    );
  }
}
