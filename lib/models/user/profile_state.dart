class ProfileState {
  const ProfileState({
    this.profileImageUrl,
    this.temporaryImagePath,
    this.currentNickname,
    this.nicknameInput,
    this.isNicknameValid,
    this.nicknameMessage,
    this.isNicknameDuplicate,
    this.buttonState = '확인 불가',
    this.birthDateInput,
    this.isBirthDateValid,
    this.birthDateMessage,
    this.canCheckBirthDate = false,
    this.gender,
    this.isGenderValid,
    this.canUpdateProfile = false,
    this.canEditProfile = false,
    //
    this.testId = const [],
    this.planId = const [],

    this.isUploading = false,
  });
  final String? profileImageUrl;
  final String? temporaryImagePath;
  final String? currentNickname;
  final String? nicknameInput;
  final bool? isNicknameValid;
  final String? nicknameMessage;
  final bool? isNicknameDuplicate;
  final String buttonState;
  final String? birthDateInput;
  final bool? isBirthDateValid;
  final String? birthDateMessage;
  final bool canCheckBirthDate;
  final String? gender;
  final bool? isGenderValid;
  final bool canUpdateProfile;
  final bool canEditProfile;
  //
  final List<String> testId;
  final List<String> planId;

  final bool isUploading;

  ProfileState copyWith({
    String? profileImageUrl,
    String? temporaryImagePath,
    String? currentNickname,
    String? nicknameInput,
    bool? isNicknameValid,
    String? nicknameMessage,
    bool? isNicknameDuplicate,
    String? buttonState,
    String? birthDateInput,
    bool? isBirthDateValid,
    String? birthDateMessage,
    bool? canCheckBirthDate,
    String? gender,
    bool? isGenderValid,
    bool? canUpdateProfile,
    bool? canEditProfile,
    //
    List<String>? testId,
    List<String>? planId,

    bool? isUploading,
  }) {
    return ProfileState(
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      temporaryImagePath: temporaryImagePath ?? this.temporaryImagePath,
      currentNickname: currentNickname ?? this.currentNickname,
      nicknameInput: nicknameInput ?? this.nicknameInput,
      isNicknameValid: isNicknameValid ?? this.isNicknameValid,
      nicknameMessage: nicknameMessage ?? this.nicknameMessage,
      isNicknameDuplicate: isNicknameDuplicate ?? this.isNicknameDuplicate,
      buttonState: buttonState ?? this.buttonState,
      birthDateInput: birthDateInput ?? this.birthDateInput,
      isBirthDateValid: isBirthDateValid ?? this.isBirthDateValid,
      birthDateMessage: birthDateMessage ?? this.birthDateMessage,
      canCheckBirthDate: canCheckBirthDate ?? this.canCheckBirthDate,
      gender: gender ?? this.gender,
      isGenderValid: isGenderValid ?? this.isGenderValid,
      canUpdateProfile: canUpdateProfile ?? this.canUpdateProfile,
      canEditProfile: canEditProfile ?? this.canEditProfile,
      //
      testId: testId ?? this.testId,
      planId: planId ?? this.planId,

      isUploading: isUploading ?? this.isUploading,
    );
  }
}
