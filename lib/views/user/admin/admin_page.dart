import 'package:flutter/material.dart';
import 'package:travel_muse_app/viewmodels/user/admin/admin_view_model.dart';

/// 관리자 권한 부여/박탈 페이지
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _emailController = TextEditingController();
  final _viewModel = AdminViewModel();

  bool _grantMode = true; // true면 부여, false면 박탈

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleAdminRole() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    try {
      if (_grantMode) {
        await _viewModel.giveAdminRole(email);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$email 에게 관리자 권한을 부여했습니다.')),
        );
      } else {
        await _viewModel.revokeAdminRole(email);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$email 의 관리자 권한을 박탈했습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('관리자 권한 설정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일 주소',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('부여'),
                Switch(
                  value: _grantMode,
                  onChanged: (value) {
                    setState(() {
                      _grantMode = value;
                    });
                  },
                ),
                const Text('박탈'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleAdminRole,
              child: Text(_grantMode ? '관리자 권한 부여' : '관리자 권한 박탈'),
            ),
          ],
        ),
      ),
    );
  }
}
