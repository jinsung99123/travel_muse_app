import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/user/auth_view_model_provider.dart';
import 'package:travel_muse_app/views/user/login/login_page.dart';

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(authViewModelProvider.notifier).deleteAccount();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
        );
        // 탈퇴 전 확인 팝업(WIP)
        // showGeneralDialog(
        //   context: context,
        //   barrierDismissible: true,
        //   barrierLabel: 'Dismiss',
        //   barrierColor: AppColors.black.withAlpha(200),
        //   transitionDuration: const Duration(milliseconds: 200),
        //   pageBuilder: (context, animation, secondaryAnimation) {
        //     return GestureDetector(
        //       onTap: () => Navigator.of(context).pop(),
        //       child: Material(
        //         type: MaterialType.transparency,
        //         child: Center(
        //           child: GestureDetector(
        //             onTap: () {},
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 16),
        //               child: CustomDialog(),
        //             ),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // );
      },

      child: Text('회원 탈퇴'),
    );
  }
}
