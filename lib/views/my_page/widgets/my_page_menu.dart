import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/plan_list_page.dart';
import 'package:travel_muse_app/views/my_page/preference_list_page.dart';

class MyPageMenu extends StatelessWidget {
  const MyPageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final titles = ['내 여행 계획 보기', '내 여행 성향', '여행 성향 재검사'];
    final icons = [Icons.flight_takeoff, Icons.explore, Icons.refresh];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.grey[200],
            ),
            onPressed: () {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlanListPage(),
                    ),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PreferenceListPage(),
                    ),
                  );
                  break;
                case 2:
                  // TODO: 여행 성향 재검사 기능 추가
                  break;
              }
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: Icon(icons[index], size: 28, color: Colors.teal),
              title: Text(
                titles[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        );
      },
    );
  }
}
