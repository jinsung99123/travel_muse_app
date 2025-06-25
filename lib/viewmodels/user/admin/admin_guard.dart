import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminGuard extends StatefulWidget {
  const AdminGuard({super.key, required this.child});
  final Widget child;

  @override
  State<AdminGuard> createState() => _AdminGuardState();
}

class _AdminGuardState extends State<AdminGuard> {
  bool _loading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
        _isAdmin = false;
      });
      return;
    }

    final token = await user.getIdTokenResult(true);
    final isAdmin = token.claims?['admin'] == true;

    setState(() {
      _isAdmin = isAdmin;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isAdmin) {
      return const Scaffold(body: Center(child: Text('관리자만 접근할 수 있습니다.')));
    }

    return widget.child;
  }
}
