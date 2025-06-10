import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/plan_list_page.dart';
import 'package:travel_muse_app/views/my_page/preference_list_page.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';

class MyPageMenu extends StatelessWidget {
  const MyPageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              '여행 일정',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          _buildMenuItem(
            title: '나의 여행',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlanListPage()),
              );
            },
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              '여행 성향 테스트',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

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

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
