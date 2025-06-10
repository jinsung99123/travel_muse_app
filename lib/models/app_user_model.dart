class AppUser {
  AppUser({
    required this.uid,
    this.nickname,
    this.profileImage,
    required this.testId,
    required this.planId,
    this.birthDate,
    this.gender,
  });

  final String uid;
  final String? nickname;
  final String? profileImage;
  final List<String> testId;
  final List<String> planId;
  final String? birthDate;
  final String? gender;

  AppUser copyWith({
    String? uid,
    String? nickname,
    String? profileImage,
    List<String>? testId,
    List<String>? planId,
    String? birthDate,
    String? gender,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      testId: testId ?? this.testId,
      planId: planId ?? this.planId,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      nickname: json['nickname'],
      profileImage: json['profileImage'],
      testId: List<String>.from(json['testId'] ?? []),
      planId: List<String>.from(json['planId'] ?? []),
      birthDate: json['birthDate'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'nackname': nickname,
    'profileImage': profileImage,
    'testId': testId,
    'planId': planId,
    'birthDate': birthDate,
    'gender': gender,
  };
}
