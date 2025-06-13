import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/app_user_model.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';
import 'package:travel_muse_app/services/auth_service.dart';

class AuthState {
  AuthState({this.user, this.appUser, this.isUserNew = false});

  final User? user;
  final AppUser? appUser;
  final bool isUserNew;

  AuthState copyWith({User? user, AppUser? appUser, bool? isUserNew}) {
    return AuthState(
      user: user ?? this.user,
      appUser: appUser ?? this.appUser,
      isUserNew: isUserNew ?? this.isUserNew,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  final _authService = AuthService();
  final _appUserRepository = AppUserRepository();

  @override
  AuthState build() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return AuthState(user: currentUser);
  }

  // 성공 시 상태 갱신, 실패 시 log 출력
  Future<void> loginWithGoogle() async {
    final result = await _authService.signInWithGoogle();

    if (result.isSuccess) {
      final user = result.data!.user;
      state = state.copyWith(user: user);

      // Firestore Database에 유저 최초 등록
      await _appUserRepository.createAppUser(user!.uid);

      log('로그인 성공: ${result.data.runtimeType}');
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

  Future<void> logout() async {
    await _authService.signOut();
    state = AuthState(); // 초기화
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
