import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/app_user_state_model.dart';
import 'package:travel_muse_app/repositories/user/app_user_repository.dart';

class AppUserViewModel extends AutoDisposeAsyncNotifier<AppUserState> {
  final _repository = AppUserRepository();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  AppUserState build() {
    fetchAppUser();
    return AppUserState();
  }

  Future<void> fetchAppUser() async {
    try {
      if (currentUser == null) return;
      final appUser = await _repository.fetchLatestAppUser(currentUser!.uid);

      if (appUser == null) return;
      state = AsyncData(
        state.value!.copyWith(
          uid: appUser.uid,
          loginProvider: appUser.loginProvider,
          loginEmail: appUser.loginEmail,
          nickname: appUser.nickname,
          profileImage: appUser.profileImage,
          birthDate: appUser.birthDate,
          gender: appUser.gender,
          planId: appUser.planId,
          testId: appUser.testId,
        ),
      );
    } catch (e) {
      log('기존 유저정보 로드 실패: $e');
    }
  }
}
