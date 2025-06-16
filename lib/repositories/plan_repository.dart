import 'package:flutter/material.dart';
import 'package:travel_muse_app/services/ai_service.dart';

class PlanRepository {
  final _aiService = AiService();

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

- 여행일수: ${days}일
- 여행 지역: $region
- 여행자 성향: $typeDescription

📌 아래 형식대로만 응답해줘. 설명 없이 **일정표만** 반환해.

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


반드시 위 형식을 그대로 지켜줘. **장소명 앞에 '- '**, 줄바꿈, 'Day N:'은 꼭 포함해줘.
장소는 유명하거나 대표적인 곳 위주로 작성하고, 너무 많은 장소는 넣지 마.
※ 장소명은 '__' 같은 특수문자 없이 실제 장소 이름으로 작성해줘.
''';

    return await _aiService.generate(prompt, context);
  }
}
