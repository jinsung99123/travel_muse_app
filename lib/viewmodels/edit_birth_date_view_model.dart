import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/validators.dart';

class EditBirthDateState {
  const EditBirthDateState({this.isValid, this.message, this.canCheck = false});
  final bool? isValid;
  final String? message;
  final bool canCheck;

  EditBirthDateState copyWith({
    bool? isValid,
    String? message,
    bool? canCheck,
  }) {
    return EditBirthDateState(
      isValid: isValid ?? this.isValid,
      message: message ?? this.message,
      canCheck: canCheck ?? this.canCheck,
    );
  }
}

class EditBirthDateViewModel extends AutoDisposeNotifier<EditBirthDateState> {
  final birthDateController = TextEditingController();

  @override
  EditBirthDateState build() {
    return const EditBirthDateState(isValid: null, message: null);
  }

  // 사용자 입력 변경 감지
  void checkInputChanged(String value) {
    if (state.isValid != null) {
      state = const EditBirthDateState(
        isValid: null,
        message: null,
        canCheck: false,
      );
    }
    final isBlank = value.trim().isEmpty;
    state = state.copyWith(canCheck: !isBlank);

    if (state.canCheck) {
      validate(value);
    }
  }

  // validator 실행
  void validate(String value) {
    final errorMessage = Validators.validateBirthDate(value);
    if (errorMessage != null) {
      state = state.copyWith(isValid: false, message: errorMessage);
    } else {
      state = state.copyWith(isValid: true, message: null);
    }
  }
}

final editBirthDateViewModelProvider =
    AutoDisposeNotifierProvider<EditBirthDateViewModel, EditBirthDateState>(
      () => EditBirthDateViewModel(),
    );
