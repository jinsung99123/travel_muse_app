import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsAgreementState {
  const TermsAgreementState({
    this.agreementState = const {
      'agreeAll': false,
      '(필수) 만 14세 이상입니다.': false,
      '(필수) 서비스 이용약관 동의': false,
      '(필수) 개인정보 처리방침 동의': false,
      '(필수) 민감정보 수집 및 이용 동의': false,
    },
  });
  final Map<String, bool> agreementState;

  TermsAgreementState copyWith({Map<String, bool>? agreementState}) {
    return TermsAgreementState(
      agreementState: agreementState ?? this.agreementState,
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

    // 인덱스 0항목인 경우
    if (term == termsKeys[0]) {
      if (!updatedAgreementStatus[term]!) {
        updatedAgreementStatus.updateAll((key, value) => true); // 모든 값 true로 설정
        state = state.copyWith(agreementState: updatedAgreementStatus);
      } else {
        updatedAgreementStatus.updateAll(
          (key, value) => false,
        ); // 모든 값 false로 설정
        state = state.copyWith(agreementState: updatedAgreementStatus);
      }
    }
    // 그 외: 특정 항목만 토글
    else {
      updatedAgreementStatus[term] = !updatedAgreementStatus[term]!;

      state = state.copyWith(agreementState: updatedAgreementStatus);
      updateAllAgreedStatus();
    }
  }

  // 다른 값에 따라 'agreeAll' value 강제 설정
  void updateAllAgreedStatus() {
    final updatedAgreementStatus = Map<String, bool>.from(state.agreementState);

    // 인덱스 0을 제외한 모든 값이 true인지 확인
    final allOtherTermsAgreed = updatedAgreementStatus.entries
        .where((entry) => entry.key != termsKeys[0]) // 인덱스 0 제외
        .every((entry) => entry.value == true);

    // 조건에 맞게 인덱스 0을 설정
    if (allOtherTermsAgreed) {
      updatedAgreementStatus[termsKeys[0]] = true;
    } else {
      updatedAgreementStatus[termsKeys[0]] = false; // 아니면 false로 설정
    }

    // 상태 갱신
    state = state.copyWith(agreementState: updatedAgreementStatus);
  }
}

final termsAgreementViewModelProvider =
    AutoDisposeNotifierProvider<TermsAgreementViewModel, TermsAgreementState>(
      () => TermsAgreementViewModel(),
    );
