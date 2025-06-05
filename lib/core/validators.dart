class Validators {
  // 닉네임
  static String? validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '닉네임은 2글자 이상이어야 하며, 한글과 숫자만 입력 가능합니다.';
    }

    final nickname = value.trim();

    final validPattern = RegExp(r'^[가-힣0-9]+$');
    if (!validPattern.hasMatch(nickname) || nickname.length < 2) {
      return '닉네임은 2글자 이상이어야 하며, 한글과 숫자만 입력 가능합니다.';
    }

    return null;
  }
}
