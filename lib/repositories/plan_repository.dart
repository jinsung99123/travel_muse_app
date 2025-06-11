// lib/repositories/plan_repository.dart

import 'package:travel_muse_app/services/ai_service.dart';

class PlanRepository {
  final _aiService = AiService();

  final Map<String, String> _typeDescriptions = {
    'planner': '철두철미 계획러: 여행은 미리미리! 엑셀표까지 만들어야 마음이 놓이죠.',
    'free_spirit': '자유로운 방랑자: 즉흥 여행이 진짜 여행! 발 닿는 대로 떠나요.',
    'nature_lover': '숲속 힐러: 사람보다 나무가 좋을 때, 자연 속 쉼이 최고의 여정입니다.',
    'city_explorer': '도시 정복자: 랜드마크와 핫플 투어는 빠짐없이, 감각적인 여행을 즐깁니다.',
    'balanced_traveler': '밸런스 마스터: 일정은 짜되, 여유도 챙기는 여행 스타일의 고수입니다.',
    'experience_seeker': '체험형 모험가: 먹어보고, 타보고, 느껴보며 오감으로 기억하는 여행러!',
  };

  Future<String> getOptimizedPlanFromAI({
    required int days,
    required String region,
    required String typeCode,
  }) async {
    final typeDescription = _typeDescriptions[typeCode] ?? typeCode;

    final prompt = '''
너는 여행 플래너야.

다음 조건을 참고해서 여행자에게 맞는 여행 계획을 작성해줘.

- 여행일수: ${days}일
- 지역: $region
- 여행자 성향: $typeDescription

각 날짜별로 추천 장소와 간단한 설명을 아래 형식으로 작성해줘. 추가 설명 없이 일정만 반환해.

예시:
Day 1:
- 장소1: 설명1
- 장소2: 설명2

Day 2:
- 장소1: 설명1
...

꼭 위 포맷을 지켜줘.
''';

    return await _aiService.generate(prompt);
  }
}
