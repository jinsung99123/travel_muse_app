import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/services/ai_service.dart';

final preferenceTestViewModelProvider =
    NotifierProvider<PreferenceTestViewModel, AsyncValue<(String, String)>>(
      () => PreferenceTestViewModel(),
    );

class PreferenceTestViewModel extends Notifier<AsyncValue<(String, String)>> {
  final _aiService = AiService();

  final Map<String, String> typeDescriptions = {
    'a': '계획형 여행가: 여행을 철저하게 계획하고 준비하는 성향입니다.',
    'b': '즉흥형 여행가: 계획보다는 즉흥적으로 여행을 즐깁니다.',
    'c': '자연친화형 여행가: 자연을 가까이에서 즐기길 원합니다.',
    'd': '도시탐험형 여행가: 도시의 문화와 랜드마크를 탐험합니다.',
    'e': '혼합형 여행가: 계획과 즉흥을 조화롭게 섞어 여행을 즐깁니다.',
    'f': '새로운 것 탐험형 여행가: 새로운 것에 대한 호기심으로 여행합니다.',
  };

  @override
  AsyncValue<(String, String)> build() => const AsyncValue.data(('', ''));

  Future<void> classifyPersonality(List<Map<String, String>> answers) async {
    state = const AsyncValue.loading();

    try {
      final resultSummary = answers
          .map((a) => '${a['question']} => ${a['selectedOption']}')
          .join(', ');

      final prompt = """
사용자의 여행 성향 테스트 결과:
$resultSummary

아래 중에서 가장 적합한 하나의 여행가 타입 코드만 골라서 반환해줘.
반드시 아래 중 하나로만 대답해. 추가 설명은 하지 말고, 코드만 반환해.

a: 계획형 여행가
b: 즉흥형 여행가
c: 자연친화형 여행가
d: 도시탐험형 여행가
e: 혼합형 여행가
f: 새로운 것 탐험형 여행가
""";

      final typeCode = await _aiService.getTypeCodeFromAI(prompt);
      final description = typeDescriptions[typeCode] ?? '알 수 없는 유형';
      state = AsyncValue.data((typeCode, description));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
