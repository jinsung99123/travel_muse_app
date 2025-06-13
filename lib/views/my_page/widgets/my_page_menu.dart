import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/my_page/plan_list_page.dart';
import 'package:travel_muse_app/views/my_page/preference_list_page.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class MyPageMenu extends StatelessWidget {
  const MyPageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuTitle('여행 일정'),

          _buildMenuItem(
            title: '나의 여행',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlanListPage()),
              );
            },
          ),

          _buildMenuTitle('여행 성향 테스트'),

          _buildMenuItem(
            title: '나의 여행 성향',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreferenceListPage(),
                ),
              );
            },
          ),

          _buildMenuItem(
            title: '여행 성향 재검사',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreferenceTestPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  ///
  /// 페이지 위젯
  ///

  Padding _buildMenuTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.grey[300],
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          height: 1.50,
        ),
      ),
    );
  }

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.grey[50]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey[600]),
          ],
        ),
      ),
    );
  }
}
