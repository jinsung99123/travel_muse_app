class UserAgreement {
  UserAgreement({
    required this.termId,
    required this.isRequired,
    required this.version,
    required this.agreed,
    required this.agreedAt,
  });

  final String termId;
  final bool isRequired;
  final String version;
  final bool agreed;
  final DateTime agreedAt;

  UserAgreement copyWith({
    String? termId,
    bool? isRequired,
    String? version,
    bool? agreed,
    DateTime? agreedAt,
  }) {
    return UserAgreement(
      termId: termId ?? this.termId,
      isRequired: isRequired ?? this.isRequired,
      version: version ?? this.version,
      agreed: agreed ?? this.agreed,
      agreedAt: agreedAt ?? this.agreedAt,
    );
  }

  factory UserAgreement.fromJson(String termId, Map<String, dynamic> json) {
    return UserAgreement(
      termId: termId,
      isRequired: json['isRequired'],
      version: json['version'],
      agreed: json['agreed'],
      agreedAt: DateTime.parse(json['agreedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'isRequired': isRequired,
    'version': version,
    'agreed': agreed,
    'agreedAt': agreedAt.toIso8601String(),
  };
}
