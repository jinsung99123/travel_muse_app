class UserAgreement {
  UserAgreement({
    required this.termId,
    required this.isRequired,
    required this.version,
    required this.agreed,
    required this.agreedAt,
    this.url,
  });

  final String termId;
  final bool isRequired;
  final String version;
  final bool agreed;
  final DateTime agreedAt;
  final String? url;

  UserAgreement copyWith({
    String? termId,
    bool? isRequired,
    String? version,
    bool? agreed,
    DateTime? agreedAt,
    String? url,
  }) {
    return UserAgreement(
      termId: termId ?? this.termId,
      isRequired: isRequired ?? this.isRequired,
      version: version ?? this.version,
      agreed: agreed ?? this.agreed,
      agreedAt: agreedAt ?? this.agreedAt,
      url: url ?? this.url,
    );
  }

  factory UserAgreement.fromJson(String termId, Map<String, dynamic> json) {
    return UserAgreement(
      termId: termId,
      isRequired: json['isRequired'] as bool,
      version: json['version'] as String,
      agreed: json['agreed'] as bool,
      agreedAt: DateTime.parse(json['agreedAt'] as String),
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'isRequired': isRequired,
    'version': version,
    'agreed': agreed,
    'agreedAt': agreedAt.toIso8601String(),
    'url': url,
  };
}
