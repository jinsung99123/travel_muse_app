import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/user/auth_view_model_provider.dart';
import 'package:travel_muse_app/views/my_page/widgets/confirm_dialog.dart';
import 'package:travel_muse_app/views/user/login/login_page.dart';

class DeleteAccountButton extends ConsumerStatefulWidget {
  const DeleteAccountButton({super.key});

  @override
  ConsumerState<DeleteAccountButton> createState() => _DeleteAccountButtonState();
}

class _DeleteAccountButtonState extends ConsumerState<DeleteAccountButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: _showConfirmDialog, child: const Text('회원 탈퇴'));
  }

  Future<void> _showConfirmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => const ConfirmDialog(
            title: '탈퇴하시겠습니까?',
            description: '작성한 글, 댓글은 자동으로 삭제되지 않아요',
          ),
    );

    if (!mounted) return;

    if (result == true) {
      await ref.read(authViewModelProvider.notifier).deleteAccount();

      if (!mounted) return;

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }
}
