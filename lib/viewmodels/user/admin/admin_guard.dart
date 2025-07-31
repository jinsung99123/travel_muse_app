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
/// 현재 로그인된 사용자가 관리자(admin) 권한을 가지고 있는지 확인
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

/// - _loading이 true일 경우 로딩 인디케이터를 보여줌
/// - _isAdmin이 false이면 관리자만 접근할 수 있습니다. 메시지를 출력
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
