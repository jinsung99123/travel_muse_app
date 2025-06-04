import 'package:cloud_firestore/cloud_firestore.dart';

class PreferenceAnswer {
  final String questionId;
  final String selectedOption;

  PreferenceAnswer({required this.questionId, required this.selectedOption});

  Map<String, String> toMap() => {
    'questionId': questionId,
    'selectedOption': selectedOption,
  };

  factory PreferenceAnswer.fromMap(Map<String, dynamic> map) {
    return PreferenceAnswer(
      questionId: map['questionId'] ?? '',
      selectedOption: map['selectedOption'] ?? '',
    );
  }
}

class PreferenceTest {
  final String testId;
  final String userId;
  final List<PreferenceAnswer> answers;
  final Map<String, String>
  result; // e.g., {'type': 'a', 'details': '계획형 여행가 ...'}
  final DateTime createdAt;
  final DateTime updatedAt;

  PreferenceTest({
    required this.testId,
    required this.userId,
    required this.answers,
    required this.result,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'testId': testId,
    'userId': userId,
    'answers': answers.map((a) => a.toMap()).toList(),
    'result': result,
    'createAt': createdAt,
    'updateAt': updatedAt,
  };

  ///Firestore에서 가져올 때 사용
  factory PreferenceTest.fromDoc(String id, Map<String, dynamic> map) {
    return PreferenceTest(
      testId: id,
      userId: map['userId'] ?? '',
      answers:
          (map['answers'] as List<dynamic>)
              .map((e) => PreferenceAnswer.fromMap(e))
              .toList(),
      result: Map<String, String>.from(map['result']),
      createdAt: (map['createAt'] as Timestamp).toDate(),
      updatedAt: (map['updateAt'] as Timestamp).toDate(),
    );
  }

  /// copyWith 메서드
  PreferenceTest copyWith({
    String? testId,
    String? userId,
    List<PreferenceAnswer>? answers,
    Map<String, String>? result,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PreferenceTest(
      testId: testId ?? this.testId,
      userId: userId ?? this.userId,
      answers: answers ?? this.answers,
      result: result ?? this.result,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
