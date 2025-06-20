import 'package:travel_muse_app/models/user/user_agreement_model.dart';

class UserAgreementState {
  const UserAgreementState({
    this.agreementList = const [],
    this.isAllAgreed = false,
    this.isAllRequiredAgreed = false,
  });
  final List<UserAgreement> agreementList;
  final bool isAllAgreed;
  final bool isAllRequiredAgreed;

  UserAgreementState copyWith({
    List<UserAgreement>? agreementList,
    bool? isAllAgreed,
    bool? isAllRequiredAgreed,
  }) {
    return UserAgreementState(
      agreementList: agreementList ?? this.agreementList,
      isAllAgreed: isAllAgreed ?? this.isAllAgreed,
      isAllRequiredAgreed: isAllRequiredAgreed ?? this.isAllRequiredAgreed,
    );
  }
}
