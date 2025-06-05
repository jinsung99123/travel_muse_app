import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/my_page/my_page.dart';

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

  void _onItemTapped(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        page = HomePage();
        break;
      case 1:
        // TODO: 일정 목록 페이지로 대체
        page = MyPage();
        break;
      case 2:
        // TODO: 추천명소 페이지로 대체
        page = MyPage();
        break;
      case 3:
        page = MyPage();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '일정'),
        BottomNavigationBarItem(icon: Icon(Icons.place), label: '추천명소'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
    );
  }
}
