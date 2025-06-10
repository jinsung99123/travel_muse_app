class Validators {
  // 닉네임
  static String? validateNickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '한글, 영문, 숫자만 사용 가능합니다 (2~8자)';
    }

    final nickname = value.trim();

    final validPattern = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    if (!validPattern.hasMatch(nickname) || nickname.length < 2) {
      return '한글, 영문, 숫자만 사용 가능합니다 (2~8자)';
    }

    return null;
  }

  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '주민등록상 생년월일 8자리를 입력해주세요';
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
