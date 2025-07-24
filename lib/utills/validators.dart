import 'dart:developer';

class Validators {
  // 닉네임
  static String? validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (value != null) {
        log(value);
      }
      return '닉네임을 입력해주세요';
    }

    final nickname = value.trim();

    final validPattern = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    if (!validPattern.hasMatch(nickname) ||
        nickname.length < 2 ||
        nickname.length > 8) {
      return '한글, 영문, 숫자만 사용 가능합니다 (2~8자)';
    }

    return null;
  }
}
