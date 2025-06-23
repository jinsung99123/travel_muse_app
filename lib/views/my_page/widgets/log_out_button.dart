import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/user/auth_view_model_provider.dart';
import 'package:travel_muse_app/views/user/login/login_page.dart';

class LogOutButton extends ConsumerWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(authViewModelProvider.notifier).logout();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
        );
      },
      child: Text('로그아웃'),
    );
  }
}
