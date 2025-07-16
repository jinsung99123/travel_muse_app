import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/my_page/like_list_page.dart';
import 'package:travel_muse_app/views/my_page/my_page.dart';
import 'package:travel_muse_app/views/my_page/my_post_page.dart';
import 'package:travel_muse_app/views/my_page/my_scrap_list_page.dart';
import 'package:travel_muse_app/views/my_page/plan_list_page.dart';
import 'package:travel_muse_app/views/my_page/preference_list_page.dart';
import 'package:travel_muse_app/views/my_page/settings/account_setting_page.dart';
import 'package:travel_muse_app/views/my_page/settings/notification_setting_page.dart';
import 'package:travel_muse_app/views/my_page/settings/service_term_page.dart';
import 'package:travel_muse_app/views/my_page/settings/setting_page.dart';
import 'package:travel_muse_app/views/my_page/settings/support_page.dart';
import 'package:travel_muse_app/views/my_page/settings/version_page.dart';
import 'package:travel_muse_app/views/preference/preference_test_page.dart';
import 'package:travel_muse_app/views/user/admin/admin_entry.dart';
import 'package:travel_muse_app/views/user/admin/admin_report_entry.dart';

class MyPageTab extends StatelessWidget {
  const MyPageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const MyPage());
        }
        if (settings.name == '/my_plan') {
          return MaterialPageRoute(builder: (_) => const PlanListPage());
        }
        if (settings.name == '/my_scrap') {
          return MaterialPageRoute(builder: (_) => const MyScrapListPage());
        }
        if (settings.name == '/my_post') {
          return MaterialPageRoute(builder: (_) => const MyPostPage());
        }
        if (settings.name == '/my_like') {
          return MaterialPageRoute(builder: (_) => const LikeListPage());
        }
        if (settings.name == '/my_preference') {
          return MaterialPageRoute(builder: (_) => const PreferenceListPage());
        }
        if (settings.name == '/preference_test') {
          return MaterialPageRoute(builder: (_) => const PreferenceTestPage());
        }
        if (settings.name == '/setting') {
          return MaterialPageRoute(builder: (_) => const SettingPage());
        }
        if (settings.name == '/notification_setting') {
          return MaterialPageRoute(
            builder: (_) => const NotificationSettingPage(),
          );
        }
        if (settings.name == '/account_setting') {
          return MaterialPageRoute(builder: (_) => const AccountSettingPage());
        }
        if (settings.name == '/service_term') {
          return MaterialPageRoute(builder: (_) => const ServiceTermPage());
        }
        if (settings.name == '/support') {
          return MaterialPageRoute(builder: (_) => const SupportPage());
        }
        if (settings.name == '/version') {
          return MaterialPageRoute(builder: (_) => const VersionPage());
        }
        if (settings.name == '/admin_entry') {
          return MaterialPageRoute(builder: (_) => const AdminEntry());
        }
        if (settings.name == '/admin_report_entry') {
          return MaterialPageRoute(builder: (_) => const AdminReportEntry());
        }
        return null;
      },
    );
  }
}
