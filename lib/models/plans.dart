import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';

class Plans {
  Plans({
    required this.planId,
    required this.title,
    required this.region,
    required this.startDate,
    required this.endDate,
    required this.userId,
    required this.date,
    required this.createdByAI,
    required this.preference,
  });

  final String planId;
  final String title;
  final String region;
  final DateTime startDate;
  final DateTime endDate;
  final String userId;
  final String date;
  final bool createdByAI;
  final PreferenceTest? preference;

  factory Plans.fromJson(String id, Map<String, dynamic> json) {
  final rawStart = json['startDate'];
  final rawEnd = json['endDate'];

  // 날짜 파싱 함수
  DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  final parsedStart = _parseDate(rawStart) ?? DateTime.now();
  final parsedEnd = _parseDate(rawEnd) ?? DateTime.now();

  final preferenceMap = json['preference'];
  PreferenceTest? preference;

  if (preferenceMap is Map<String, dynamic> &&
      preferenceMap['answers'] != null) {
    try {
      preference = PreferenceTest.fromDoc('', Map<String, dynamic>.from(preferenceMap));
    } catch (e) {
      print('❌ Preference 파싱 실패: $e');
    }
  }

  return Plans(
    planId: json['planId'] ?? id,
    title: json['title'] ?? '',
    region: json['region'] ?? '',
    startDate: parsedStart,
    endDate: parsedEnd,
    userId: json['userId'] ?? '',
    date: json['date'] ?? '',
    createdByAI: json['createdByAI'] ?? false,
    preference: preference,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'title': title,
      'region': region,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'userId': userId,
      'date': date,
      'createdByAI': createdByAI,
      'preference': preference?.toMap(),
    };
  }
}
