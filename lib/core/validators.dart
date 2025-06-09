class Validators {
  // 닉네임
  static String? validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '닉네임은 2글자 이상이어야 하며 한글, 숫자, 영문만 입력 가능합니다.';
    }

    final nickname = value.trim();

    final validPattern = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    if (!validPattern.hasMatch(nickname) || nickname.length < 2) {
      return '닉네임은 2글자 이상이어야 하며 한글, 숫자, 영문만 입력 가능합니다.';
    }

    return null;
  }

  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '생년월일을 입력해주세요.';
    }

    final birth = value.trim();

    // 1. 숫자만 입력
    if (!RegExp(r'^\d+$').hasMatch(birth)) {
      return '생년월일을 8자리로 정확하게 입력해 주세요';
    }

    // 2. 8자리인지 확인
    if (birth.length != 8) {
      return '생년월일을 8자리로 정확하게 입력해 주세요';
    }

    // 3. 앞 두 글자: 19 또는 20
    final firstTwoLetters = birth.substring(0, 2);
    if (firstTwoLetters != '19' && firstTwoLetters != '20') {
      return '생년월일을 8자리로 정확하게 입력해 주세요';
    }
    return null;
  }
}
