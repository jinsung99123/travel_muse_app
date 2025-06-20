class Terms {
  Terms({
    required this.title,
    required this.content,
    required this.isRequired,
    required this.version,
    required this.createdAt,
    required this.order,
  });

  final String title;
  final String content;
  final bool isRequired;
  final String version;
  final DateTime createdAt;
  final int order;

  Terms copyWith({
    String? title,
    String? content,
    bool? isRequired,
    String? version,
    DateTime? createdAt,
    int? order,
  }) {
    return Terms(
      title: title ?? this.title,
      content: content ?? this.content,
      isRequired: isRequired ?? this.isRequired,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      order: order ?? this.order,
    );
  }

  factory Terms.fromJson(String id, Map<String, dynamic> json) {
    return Terms(
      title: json['title'],
      content: json['content'],
      isRequired: json['isRequired'],
      version: json['version'],
      createdAt: DateTime.parse(json['createdAt']),
      order: (json['order'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'isRequired': isRequired,
    'version': version,
    'createdAt': createdAt.toIso8601String(),
    'order': order,
  };
}
