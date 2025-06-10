import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/validators.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';

class EditNicknameState {
  const EditNicknameState({
    this.isValid,
    this.message,
    this.canCheck = false,
    this.isDuplicate,
  });
  final bool? isValid;
  final String? message;
  final bool canCheck;
  final bool? isDuplicate;

  EditNicknameState copyWith({
    bool? isValid,
    String? message,
    bool? canCheck,
    bool? isDuplicate,
  }) {
    return EditNicknameState(
      isValid: isValid ?? this.isValid,
      message: message ?? this.message,
      canCheck: canCheck ?? this.canCheck,
      isDuplicate: isDuplicate ?? this.isDuplicate,
    );
  }
}

class EditNicknameViewModel extends AutoDisposeNotifier<EditNicknameState> {
  static const String _defaultMessage = '2~8자 닉네임을 입력하세요.';

  final nicknameController = TextEditingController();
  final nicknameFormkey = GlobalKey<FormState>();

  final appUserRepo = AppUserRepository();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  EditNicknameState build() {
    return const EditNicknameState(isValid: null, message: _defaultMessage);
  }

  // 사용자 입력 변경 감지
  void checkInputChanged(String value) {
    // 이미 중복확인 한 경우 : 확인된 isValid, isDuplicate를 reset
    if (state.isValid != null) {
      reset();
    }
    // 중복 확인 가능한지 확인
    final isBlank = value.trim().isEmpty;
    state = state.copyWith(canCheck: !isBlank);
  }

  // validator 실행
  void validate(String nickname) {
    final errorMessage = Validators.validateNickname(nickname);
    if (errorMessage != null) {
      state = state.copyWith(isValid: false, message: errorMessage);
    } else {
      state = state.copyWith(isValid: true, message: null);
    }
  }

  // 중복 확인
  Future<void> isNicknameDuplicate(String nickname) async {
    if (state.isDuplicate == null) {
      state = state.copyWith(message: null);
    }
    final checkIsDuplicate = await appUserRepo.isNicknameDuplicate(nickname);
    state = state.copyWith(isDuplicate: checkIsDuplicate);
    if (checkIsDuplicate) {
      state = state.copyWith(
        isDuplicate: checkIsDuplicate,
        message: '이미 사용중인 닉네임입니다.',
      );
    } else {
      state = state.copyWith(
        isDuplicate: checkIsDuplicate,
        message: '사용 가능한 닉네임입니다.',
      );
    }
  }

  // 닉네임 사용 가능 여부 확인
  Future<bool> checkCanUseNickname(String nickname) async {
    log('닉네임 사용가능여부 확인 시작');
    validate(nickname);
    if (state.isValid == null) return false;
    if (!state.isValid!) return false;
    log('닉네임 validate 통과');
    await isNicknameDuplicate(nickname);
    if (state.isDuplicate == null) return false;
    if (state.isDuplicate!) return false;
    log('닉네임 중복 검사 통과, 닉네임 사용 가능');

    return true;
  }

  // 닉네임 업데이트
  Future<void> updateNickname() async {
    if (state.isValid == null || state.isValid == false) return;

    try {
      if (currentUser == null) {
        log('currentUser is null');
        return;
      }

      // 닉네임 업데이트
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

  void reset() {
    state = const EditNicknameState(
      isValid: null,
      isDuplicate: null,
      message: _defaultMessage,
    );
  }
}

final editNicknameViewModelProvider =
    AutoDisposeNotifierProvider<EditNicknameViewModel, EditNicknameState>(
      () => EditNicknameViewModel(),
    );
