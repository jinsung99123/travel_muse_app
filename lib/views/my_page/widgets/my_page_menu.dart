import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class MyPageMenu extends StatelessWidget {
  const MyPageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMenuTitle('내 활동'),

            _buildMenuItem(
              title: '나의 여행',
              onTap: () {
                Navigator.of(context).pushNamed('/my_plan');
              },
            ),

            _buildMenuItem(
              title: '북마크',
              onTap: () {
                Navigator.of(context).pushNamed('/my_scrap');
              },
            ),

            _buildMenuItem(
              title: '내 게시글',
              onTap: () {
                Navigator.of(context).pushNamed('/my_post');
              },
            ),

            _buildMenuItem(
              title: '좋아요한 게시글',
              onTap: () {
                Navigator.of(context).pushNamed('/my_like');
              },
            ),

            _buildMenuTitle('여행 성향 테스트'),

            _buildMenuItem(
              title: '나의 여행 성향',
              onTap: () {
                Navigator.of(context).pushNamed('/my_preference');
              },
            ),

            _buildMenuItem(
              title: '여행 성향 재검사',
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const PreferenceTestPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
