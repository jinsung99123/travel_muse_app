class Terms {
  Terms({
    required this.termId,
    required this.title,
    required this.content,
    required this.isRequired,
    required this.version,
    required this.createdAt,
  });

  final String termId;
  final String title;
  final String content;
  final bool isRequired;
  final String version;
  final DateTime createdAt;

  Terms copyWith({
    String? termId,
    String? title,
    String? content,
    bool? isRequired,
    String? version,
    DateTime? createdAt,
  }) {
    return Terms(
      termId: termId ?? this.termId,
      title: title ?? this.title,
      content: content ?? this.content,
      isRequired: isRequired ?? this.isRequired,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Terms.fromJson(String id, Map<String, dynamic> json) {
    return Terms(
      termId: id,
      title: json['title'],
      content: json['content'],
      isRequired: json['isRequired'],
      version: json['version'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'isRequired': isRequired,
    'version': version,
    'createdAt': createdAt.toIso8601String(),
  };
}
