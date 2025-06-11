import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class TermsAgreementViewModel extends AutoDisposeNotifier<TermsAgreementState> {
  // 키만 관리하는 리스트
  late List<String> termsKeys;
  @override
  TermsAgreementState build() {
    final state = TermsAgreementState();
    termsKeys = state.agreementState.keys.toList();

    return state;
  }

  void toggleAgreement(String term) {
    final updatedAgreementStatus = Map<String, bool>.from(state.agreementState);

    // 인덱스 0항목인 경우 다른 모든 항목 value 변경
    if (term == termsKeys[0]) {
      if (!updatedAgreementStatus[term]!) {
        updatedAgreementStatus.updateAll((key, value) => true);
        state = state.copyWith(agreementState: updatedAgreementStatus);
      } else {
        updatedAgreementStatus.updateAll((key, value) => false);
        state = state.copyWith(agreementState: updatedAgreementStatus);
      }
    } else {
      updatedAgreementStatus[term] = !updatedAgreementStatus[term]!;

      state = state.copyWith(agreementState: updatedAgreementStatus);
      updateAllAgreedStatus();
    }
    allRequiredTermsAgreed();
  }

  // 다른 값에 따라 'agreeAll' value 강제 설정
  void updateAllAgreedStatus() {
    final updatedAgreementStatus = Map<String, bool>.from(state.agreementState);

    // 인덱스 0을 제외한 모든 값이 true인지 확인
    final allOtherTermsAgreed = updatedAgreementStatus.entries
        .where((entry) => entry.key != termsKeys[0]) // 인덱스 0 제외
        .every((entry) => entry.value == true);

    if (allOtherTermsAgreed) {
      updatedAgreementStatus[termsKeys[0]] = true;
    } else {
      updatedAgreementStatus[termsKeys[0]] = false;
    }

    state = state.copyWith(agreementState: updatedAgreementStatus);
  }

  // (필수) 항목 모두 true인지 확인
  void allRequiredTermsAgreed() {
    final requiredTerms = state.agreementState.entries
        .where((entry) => entry.key.contains('''(필수)'''))
        .every((entry) => entry.value == true);

    state = state.copyWith(allRequiresAgreed: requiredTerms);
  }
}

final termsAgreementViewModelProvider =
    AutoDisposeNotifierProvider<TermsAgreementViewModel, TermsAgreementState>(
      () => TermsAgreementViewModel(),
    );
