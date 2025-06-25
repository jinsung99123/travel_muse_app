import 'package:flutter/material.dart';
import 'package:travel_muse_app/viewmodels/user/admin/admin_guard.dart';
import 'package:travel_muse_app/views/user/admin/admin_page.dart';

class AdminEntry extends StatelessWidget {
  const AdminEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminGuard(
      child: AdminPage(),
    );
  }
}
