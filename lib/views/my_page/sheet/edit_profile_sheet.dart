import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';
import 'package:travel_muse_app/views/my_page/sheet/widgets/appbar_button.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';

class EditProfileSheet extends ConsumerWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileViewmodel = ref.read(profileViewModelProvider.notifier);
    final profileState = ref.watch(profileViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        // 취소
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          '프로필 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // 완료, 제출
          AppbarButton(
            widget: const Text('완료', style: TextStyle(fontSize: 18)),
            onPressed: () async {
              log('onpress');
              FocusScope.of(context).unfocus();

              await profileViewmodel.updateNickname();

              if (profileState.temporaryImagePath != null) {
                await profileViewmodel.updateProfileImage();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            EditProfileImage(size: 120),
            const SizedBox(height: 20),
            EditNickname(controller: profileViewmodel.nicknameController),
          ],
        ),
      ),
    );
  }
}
