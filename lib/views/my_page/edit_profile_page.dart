import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/views/widgets/edit_nickname.dart';
import 'package:travel_muse_app/views/widgets/edit_profile_image.dart';
import 'package:travel_muse_app/views/widgets/user_next_button.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewmodel = ref.read(profileViewModelProvider.notifier);
    final state = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '프로필 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            ListView(children: [EditProfileImage(), EditNickname()]),
            Column(
              children: [
                Spacer(),
                UserNextButton(
                  text: '저장하기',
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await viewmodel.editProfile();
                    navigator.pop(true);
                  },
                  isActivated: state.canEditProfile,
                ),
                SizedBox(height: 34),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
