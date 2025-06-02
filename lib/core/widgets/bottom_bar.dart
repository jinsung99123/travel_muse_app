import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {

  const BottomBar({
    super.key,
    required this.primaryColor,
    required this.currentIndex,
    required this.onTap,
  });
  final Color primaryColor;
  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '일정'),
        BottomNavigationBarItem(icon: Icon(Icons.place), label: '추천명소'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
    );
  }
}
