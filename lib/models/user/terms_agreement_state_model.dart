class TermsAgreementState {
  const TermsAgreementState({
    this.agreementState = const {
      'agreeAll': false,
      '(필수) 만 14세 이상입니다.': false,
      '(필수) 서비스 이용약관 동의': false,
      '(필수) 개인정보 처리방침 동의': false,
      '(필수) 민감정보 수집 및 이용 동의': false,
      '(선택) 마케팅 수신 동의': false,
    },
    this.allRequiresAgreed = false,
  });
  final Map<String, bool> agreementState;
  final bool allRequiresAgreed;

  TermsAgreementState copyWith({
    Map<String, bool>? agreementState,
    bool? allRequiresAgreed,
  }) {
    return TermsAgreementState(
      agreementState: agreementState ?? this.agreementState,
      allRequiresAgreed: allRequiresAgreed ?? this.allRequiresAgreed,
    );
  }
}
