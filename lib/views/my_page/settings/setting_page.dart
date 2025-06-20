import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/my_page/settings/account_setting_page.dart';
import 'package:travel_muse_app/views/my_page/settings/environment_setting_page.dart';
import 'package:travel_muse_app/views/my_page/settings/notification_setting_page.dart';
import 'package:travel_muse_app/views/my_page/settings/service_term_page.dart';
import 'package:travel_muse_app/views/my_page/settings/support_page.dart';
import 'package:travel_muse_app/views/my_page/settings/version_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingsItems = [
      {'title': '알림 설정', 'route': const NotificationSettingPage()},
      {'title': '환경 설정', 'route': const EnvironmentSettingPage()},
      {'title': '계정 관리', 'route': const AccountSettingPage()},
      {'title': '서비스 약관', 'route': const ServiceTermPage()},
      {'title': '고객 지원', 'route': const SupportPage()},
      {'title': '버전 정보', 'route': const VersionPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: settingsItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => settingsItems[index]['route'],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: AppColors.grey[50]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      settingsItems[index]['title'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.grey[600],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
