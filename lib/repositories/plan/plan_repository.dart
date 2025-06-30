import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/services/plan/ai_service.dart';

class PlanRepository {
  final _aiService = AiService();
  final _firestore = FirebaseFirestore.instance;

  final Map<String, String> _typeDescriptions = {
    '계획러': '철두철미 계획러: 여행은 미리미리! 엑셀표까지 만들어야 마음이 놓이죠.',
    '자유인': '자유로운 방랑자: 즉흥 여행이 진짜 여행! 발 닿는 대로 떠나요.',
    '자연인': '숲속 힐러: 사람보다 나무가 좋을 때, 자연 속 쉼이 최고의 여정입니다.',
    '도시러': '도시 정복자: 랜드마크와 핫플 투어는 빠짐없이, 감각적인 여행을 즐깁니다.',
    '균형러': '밸런스 마스터: 일정은 짜되, 여유도 챙기는 여행 스타일의 고수입니다.',
    '모험가': '체험형 모험가: 먹어보고, 타보고, 느껴보며 오감으로 기억하는 여행러!',
  };

  Future<String> getOptimizedPlanFromAI({
    required int days,
    required String region,
    required String typeCode,
    required BuildContext context,
  }) async {
    final typeDescription = _typeDescriptions[typeCode] ?? typeCode;

    final prompt = '''
너는 여행 플래너야.

여행자에게 맞는 일정표를 아래 조건에 따라 만들어줘:

- 여행일수: $days일
- 여행 지역: $region
- 여행자 성향: $typeDescription

📌 아래 형식대로만 응답해줘. 설명 없이 **일정표만** 반환해. 장소명은 실제 장소로. 특수문자 없이. 간결하게.

---
Day 1:
- 장소1: 간단한 설명1
- 장소2: 간단한 설명2

Day 2:
- 장소1: 간단한 설명1
- 장소2: 간단한 설명2
...

Day N:
- 장소1: 설명1
- 장소2: 설명2



''';

    return await _aiService.generate(prompt, context);
  }

  /// AI 추천 횟수가 3회 미만인지 확인
  Future<bool> isAiRecommendationAllowed(String planId) async {
    final doc = await _firestore.collection('plans').doc(planId).get();
    final count = (doc.data()?['ai_attempt_count'] ?? 0) as int;
    return count < 3;
  }

  /// AI 추천 횟수 1 증가
  Future<void> incrementAiAttemptCount(String planId) async {
    await _firestore.collection('plans').doc(planId).set({
      'ai_attempt_count': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }
}
