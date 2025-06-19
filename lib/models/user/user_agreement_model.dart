class UserAgreement {
  UserAgreement({
    required this.termId,
    required this.version,
    required this.agreed,
    required this.agreedAt,
  });

  final String termId;
  final String version;
  final bool agreed;
  final DateTime agreedAt;

  UserAgreement copyWith({
    String? termId,
    String? version,
    bool? agreed,
    DateTime? agreedAt,
  }) {
    return UserAgreement(
      termId: termId ?? this.termId,
      version: version ?? this.version,
      agreed: agreed ?? this.agreed,
      agreedAt: agreedAt ?? this.agreedAt,
    );
  }
}
