import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/terms_model.dart';
import 'package:travel_muse_app/models/user/user_agreement_model.dart';
import 'package:travel_muse_app/models/user/user_agreement_state_model.dart';
import 'package:travel_muse_app/repositories/user/app_user_repository.dart';

class UserAgreementViewModel extends AutoDisposeNotifier<UserAgreementState> {
  @override
  UserAgreementState build() {
    final state = UserAgreementState();

    return state;
  }

  /// UserAgreement 리스트 초기 설정
  void setUserAgreementList(List<Terms> terms) {
    final List<UserAgreement> initialAgreements =
        terms.map((term) {
          return UserAgreement(
            termId: term.id,
            isRequired: term.isRequired,
            version: term.version,
            agreed: false,
            agreedAt: DateTime.now(),
          );
        }).toList();

    state = state.copyWith(agreementList: initialAgreements);
  }

  /// 특정 UserAgreement get
  UserAgreement getAgreementByTermId(String termId) {
    return state.agreementList.firstWhere(
      (agreement) => agreement.termId == termId,
    );
  }

  /// 특정 UserAgreement 동의 여부 get
  bool isAgreementAgreedByTermId(String termId) {
    final userAgreement = getAgreementByTermId(termId);
    return userAgreement.agreed;
  }

  /// 모든 약관이 동의되었는지 확인
  void checkAllAgreed() {
    final allAgreed = state.agreementList.every(
      (agreement) => agreement.agreed,
    );

    state = state.copyWith(isAllAgreed: allAgreed);
  }

  /// 모든 필수 약관이 동의되었는지 확인
  void checkAllRequiredAgreed() {
    final requiredAgreements =
        state.agreementList.where((a) => a.isRequired).toList();

    final allRequiredAgreed = requiredAgreements.every(
      (agreement) => agreement.agreed,
    );

    state = state.copyWith(isAllRequiredAgreed: allRequiredAgreed);
  }

  /// 특정 UserAgreement의 동의 여부 토글
  void toggleAgreedByTermId({required String termId, required bool agreeOnly}) {
    final index = state.agreementList.indexWhere(
      (agreement) => agreement.termId == termId,
    );

    if (index == -1) {
      log('termId "$termId"에 해당하는 UserAgreement를 찾을 수 없습니다.');
      return;
    }
    final targetUserAgreement = state.agreementList[index];
    late final UserAgreement updated;
    !agreeOnly
        ? updated = targetUserAgreement.copyWith(
          agreed: !targetUserAgreement.agreed,
          agreedAt:
              !targetUserAgreement.agreed
                  ? DateTime.now()
                  : targetUserAgreement.agreedAt,
        )
        : updated = targetUserAgreement.copyWith(
          agreed: true,
          agreedAt: DateTime.now(),
        );

    final updatedList = [...state.agreementList];
    updatedList[index] = updated;

    state = state.copyWith(agreementList: updatedList);
    checkAllAgreed();
    checkAllRequiredAgreed();
  }

  /// '모두 동의' 토글
  /// 모든 agreed 값 isAllAgreed로 변경
  void toggleAllAgreed() {
    final newValue = !state.isAllAgreed;

    final updatedList =
        state.agreementList.map((agreement) {
          return agreement.copyWith(
            agreed: newValue,
            agreedAt: newValue ? DateTime.now() : agreement.agreedAt,
          );
        }).toList();

    state = state.copyWith(agreementList: updatedList, isAllAgreed: newValue);
    checkAllRequiredAgreed();
  }

  // 유저 동의 정보 서버 업로드
  Future<void> uploadUserAgreements() async {
    final repository = AppUserRepository();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await repository.uploadUserAgreements(user.uid, state.agreementList);
  }
}
