import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_places_list_page.dart';
import 'package:travel_muse_app/views/my_page/my_page.dart';
import 'package:travel_muse_app/views/my_page/plan_list_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  final Color primaryColor = const Color(0xFF03A9F4);

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    Widget page;

    switch (index) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const PlanListPage();
        break;
      case 2:
        page = const RecommendedPlacesListPage();
        break;
      case 3:
        page = const MyPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': '홈'},
      {'icon': Icons.calendar_today, 'label': '일정 목록'},
      {'icon': Icons.place, 'label': '추천명소'},
      {'icon': Icons.person, 'label': '마이페이지'},
    ];

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE9EBEB), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == _currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onItemTapped(index),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 56,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[index]['icon'] as IconData,
                      size: 24,
                      color: isSelected ? primaryColor : Colors.grey,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? primaryColor : Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
