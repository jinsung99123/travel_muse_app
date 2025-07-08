import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/views/my_page/settings/account_setting_page.dart';
import 'package:travel_muse_app/views/my_page/settings/notification_setting_page.dart';
import 'package:travel_muse_app/views/my_page/settings/service_term_page.dart';
import 'package:travel_muse_app/views/my_page/settings/support_page.dart';
import 'package:travel_muse_app/views/my_page/settings/version_page.dart';
import 'package:travel_muse_app/views/user/admin/admin_entry.dart';
import 'package:travel_muse_app/views/user/admin/admin_report_entry.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isAdmin = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdTokenResult(true);
      setState(() {
        _isAdmin = token.claims?['admin'] == true;
      });
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Map<String, dynamic>> settingsItems = [
      {'title': '알림 설정', 'route': const NotificationSettingPage()},
      {'title': '계정 관리', 'route': const AccountSettingPage()},
      {'title': '서비스 약관', 'route': const ServiceTermPage()},
      {'title': '고객 지원', 'route': const SupportPage()},
      {'title': '버전 정보', 'route': const VersionPage()},
      if (_isAdmin)
        {'title': '운영자 권한 설정', 'route': const AdminEntry()},
      if (_isAdmin)
        {'title': '신고 컨텐츠 관리', 'route': const AdminReportEntry()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '설정',
          style: TextStyle(color: AppColors.grey[800]),
        ),
        leading:
            Navigator.canPop(context)
                ? const CustomBackButton()
                : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: AppColors.grey[50]!,
                    ),
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
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
