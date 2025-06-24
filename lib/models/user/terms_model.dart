class Terms {
  Terms({
    required this.id,
    required this.title,
    required this.content,
    required this.isRequired,
    required this.version,
    required this.createdAt,
    required this.order,
    required this.url,
  });

  final String id;
  final String title;
  final String content;
  final bool isRequired;
  final String version;
  final DateTime createdAt;
  final int order;
  final String url;

  Terms copyWith({
    String? id,
    String? title,
    String? content,
    bool? isRequired,
    String? version,
    DateTime? createdAt,
    int? order,
    String? url,
  }) {
    return Terms(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isRequired: isRequired ?? this.isRequired,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      order: order ?? this.order,
      url: url ?? this.url,
    );
  }

  factory Terms.fromJson(String id, Map<String, dynamic> json) {
    return Terms(
      id: json['id'] ?? id,
      title: json['title'],
      content: json['content'],
      isRequired: json['isRequired'],
      version: json['version'],
      createdAt: DateTime.parse(json['createdAt']),
      order: (json['order'] as num).toInt(),
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'isRequired': isRequired,
    'version': version,
    'createdAt': createdAt.toIso8601String(),
    'order': order,
    'url': url,
  };
}
