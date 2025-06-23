class Report {
  final String targetType;       // post or comment
  final String targetId;         // 게시글ID or 댓글 ID
  final String reporterId;       // 신고한 사람
  final String targetOwnerId;    // 신고 당한 사람
  final String reasonCode;       // SPAM, HATE, NUDITY, ETC
  final String? reasonText;      // 추가 설명 (선택)
  final DateTime timestamp;      // 신고 시각

  Report({
    required this.targetType,
    required this.targetId,
    required this.reporterId,
    required this.targetOwnerId,
    required this.reasonCode,
    this.reasonText,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'targetType': targetType,
    'targetId': targetId,
    'reporterId': reporterId,
    'targetOwnerId': targetOwnerId,
    'reasonCode': reasonCode,
    'reasonText': reasonText,
    'timestamp': timestamp.toIso8601String(),
  };
}
