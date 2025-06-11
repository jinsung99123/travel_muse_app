import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/app_user_model.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';
import 'package:travel_muse_app/services/auth_service.dart';

class AuthState {
  AuthState({this.user});

  final User? user;

  AuthState copyWith({User? user, AppUser? currentAppUser}) {
    return AuthState(user: user ?? this.user);
  }
}

class AuthViewModel extends Notifier<AuthState> {
  final _authService = AuthService();
  final _appUserRepository = AppUserRepository();

  @override
  AuthState build() => AuthState();

  // 성공 시 상태 갱신, 실패 시 log 출력
  Future<void> loginWithGoogle() async {
    final result = await _authService.signInWithGoogle();

    if (result.isSuccess) {
      final user = result.data!.user;
      state = state.copyWith(user: user);

      // Firestore Database에 유저 최초 등록
      await _appUserRepository.createAppUser(user!.uid);

      log('로그인 성공: ${result.data.runtimeType}');
    } else {
      log('로그인 실패: ${result.error}');
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    state = AuthState(); // 초기화
  }

  // TODO: 로그인 성공 시 Home으로 or 온보딩으로 이동 조건 분기 메서드
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
