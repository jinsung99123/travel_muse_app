import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/auth_state.dart';
import 'package:travel_muse_app/repositories/user/app_user_repository.dart';
import 'package:travel_muse_app/services/user/auth_service.dart';

class AuthViewModel extends Notifier<AuthState> {
  final _authService = AuthService();
  final _appUserRepository = AppUserRepository();

  @override
  AuthState build() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return AuthState(user: currentUser);
  }

  // 구글 로그인
  Future<void> loginWithGoogle() async {
    final result = await _authService.signInWithGoogle();

    if (result.isSuccess) {
      final user = result.data!.user;
      state = state.copyWith(user: user);

      // Firestore Database에 유저 최초 등록
      await _appUserRepository.createAppUser(user!.uid);

      log('google로 로그인 성공: ${result.data!.user!.uid}');
      await isUserNew();
    } else {
      log('로그인 실패: ${result.error}');
    }
  }

  // 애플 로그인
  Future<void> loginWithApple() async {
    final result = await _authService.signInWithApple();

    if (result.isSuccess) {
      final user = result.data!.user;
      state = state.copyWith(user: user);

      // Firestore Database에 유저 최초 등록
      await _appUserRepository.createAppUser(user!.uid);

      log('apple로 로그인 성공: ${result.data!.user!.uid}');
      await isUserNew();
    } else {
      log('로그인 실패: ${result.error}');
    }
  }

  // appUser 확인 => 온보딩 필요 여부 결정
  Future<void> isUserNew() async {
    if (state.user == null) return;

    final currentAppUser = await _appUserRepository.fetchLatestAppUser(
      state.user!.uid,
    );
    state = state.copyWith(appUser: currentAppUser);
    if (state.appUser == null) {
      state = state.copyWith(isUserNew: null);
      return;
    }

    if (state.appUser!.nickname == null && state.appUser!.testId.isEmpty) {
      state = state.copyWith(isUserNew: true);
      return;
    }
  }

  // 로그아웃
  Future<void> logout() async {
    await _authService.signOut();
    state = AuthState(); // 초기화
  }
}
