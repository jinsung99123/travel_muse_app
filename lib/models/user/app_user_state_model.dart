class AppUserState {
  AppUserState({
    this.uid,
    this.loginProvider,
    this.loginEmail,
    this.nickname,
    this.profileImage,
    this.testId = const [],
    this.planId = const [],
    this.birthDate,
    this.gender,
  });

  final String? uid;
  final String? loginProvider;
  final String? loginEmail;
  final String? nickname;
  final String? profileImage;
  final List<String> testId;
  final List<String> planId;
  final String? birthDate;
  final String? gender;

  AppUserState copyWith({
    String? uid,
    String? loginProvider,
    String? loginEmail,
    String? nickname,
    String? profileImage,
    List<String>? testId,
    List<String>? planId,
    String? birthDate,
    String? gender,
  }) {
    return AppUserState(
      uid: uid ?? this.uid,
      loginProvider: loginProvider ?? this.loginProvider,
      loginEmail: loginEmail ?? this.loginEmail,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      testId: testId ?? this.testId,
      planId: planId ?? this.planId,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
    );
  }
}
