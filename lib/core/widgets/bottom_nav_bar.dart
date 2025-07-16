import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/bottom_bar_provider.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_places_list_page.dart';
import 'package:travel_muse_app/views/my_page/my_page.dart';
import 'package:travel_muse_app/views/post/post_list_page.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomBarProvider);

    final items = [
      {
        'selectedIcon': 'assets/icons/icon_active/home.svg',
        'unselectedIcon': 'assets/icons/home.svg',
        'label': '홈',
      },
      {
        'selectedIcon': 'assets/icons/icon_active/map-pin.svg',
        'unselectedIcon': 'assets/icons/map-pin.svg',
        'label': '추천명소',
      },
      {
        'selectedIcon': 'assets/icons/icon_active/message-circle.svg',
        'unselectedIcon': 'assets/icons/message-circle.svg',
        'label': '커뮤니티',
      },
      {
        'selectedIcon': 'assets/icons/icon_active/user.svg',
        'unselectedIcon': 'assets/icons/user.svg',
        'label': '마이페이지',
      },
    ];

    final pages = [
      const HomePage(),
      const RecommendedPlacesListPage(),
      const PostListPage(),
      const MyPage(),
    ];

    void onItemTapped(int index) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ref.read(bottomBarProvider.notifier).state = index;
    }

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: Container(
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE9EBEB), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = index == currentIndex;
            final String iconPath =
                isSelected
                    ? items[index]['selectedIcon']!
                    : items[index]['unselectedIcon']!;
            final String label = items[index]['label']!;

            return Expanded(
              child: GestureDetector(
                onTap: () => onItemTapped(index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(iconPath, width: 24, height: 24),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isSelected
                                  ? AppColors.primary[300]!
                                  : Colors.black,
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
      ),
    );
  }
}
