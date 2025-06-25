import 'package:flutter/material.dart';
import 'package:travel_muse_app/viewmodels/user/admin/admin_guard.dart';
import 'package:travel_muse_app/views/user/admin/admin_report_screen.dart';

class AdminReportEntry extends StatelessWidget {
  const AdminReportEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminGuard(
      child: AdminReportScreen(),
    );
  }
}
