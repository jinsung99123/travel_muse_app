import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';

class ProfileState {
  const ProfileState({this.nickname, this.profileImageUrl});
  final String? nickname;
  final String? profileImageUrl;
}

class ProfileViewModel extends AutoDisposeNotifier<ProfileState> {
  final appUserRepo = AppUserRepository();
  final currentUser = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();

  @override
  ProfileState build() {
    return const ProfileState();
  }

  Future<void> updateNickname() async {
    try {
      if (currentUser == null) {
        log('no currentUser');
        return;
      }

      log('CurrentUser valid');
      // 닉네임 validator 확인
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) return;
      log(
        '닉네임 업데이트 시도 - user ${currentUser!.uid}, 새 닉네임 : ${nicknameController.text}',
      );
      await appUserRepo.updateNickname(
        uid: currentUser!.uid,
        nickname: nicknameController.text,
      );
    } catch (e) {
      log('닉네임 업데이트 실패 : $e');
    }
  }
}
