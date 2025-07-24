import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/app_user_model.dart';
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

  // db에서 현재 로그인한 appUser 가져오기
  Future<AppUser?> fetchAppUser() async {
    try {
      if (currentUser == null) return null;
      final appUser = await _repository.fetchLatestAppUser(currentUser!.uid);

      if (appUser == null) return null;
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
      return appUser;
    } catch (e) {
      log('기존 유저정보 로드 실패: $e');
      return null;
    }
  }

  // 현재 유저의 appUser 문서 존재여부 확인
  Future<bool> doesUserDocumentExist(String uid) async {
    try {
      return await _repository.doesUserDocumentExist(uid);
    } catch (e) {
      log('해당 uid 문서 존재 여부 확인 실패 : $e');
      return false;
    }
  }
}
