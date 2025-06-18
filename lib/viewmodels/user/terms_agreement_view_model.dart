import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/terms_agreement_state_model.dart';

class TermsAgreementViewModel extends AutoDisposeNotifier<TermsAgreementState> {
  // 키만 관리하는 리스트
  late List<String> termsKeys;

  @override
  TermsAgreementState build() {
    final state = TermsAgreementState();
    termsKeys = state.agreementState.keys.toList();

    return state;
  }

  // 약관 상태 bool 값 변경하는 메서드
  void toggleAgreement(String term) {
    final updatedAgreementStatus = Map<String, bool>.from(state.agreementState);

    // 인덱스 0항목인 경우 다른 모든 항목 value 변경 ('모두 동의하기')
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

  // 하위 약관 bool 값 따라 'agreeAll' 값 강제 설정
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

  // '(필수)'포함 항목 모두 true인지 확인
  void allRequiredTermsAgreed() {
    final requiredTerms = state.agreementState.entries
        .where((entry) => entry.key.contains('''(필수)'''))
        .every((entry) => entry.value == true);

    state = state.copyWith(allRequiresAgreed: requiredTerms);
  }
}
