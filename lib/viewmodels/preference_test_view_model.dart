import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';
import 'package:travel_muse_app/services/ai_service.dart';
import 'package:travel_muse_app/services/preference_test_service.dart';

final preferenceTestViewModelProvider =
    NotifierProvider<PreferenceTestViewModel, AsyncValue<PreferenceTest?>>(
      () => PreferenceTestViewModel(),
    );

class PreferenceTestViewModel extends Notifier<AsyncValue<PreferenceTest?>> {
  final _aiService = AiService();
  final _service = PreferenceTestService();

  final Map<String, String> typeDescriptions = {
    'a': '계획형 여행가: 여행을 철저하게 계획하고 준비하는 성향입니다.',
    'b': '즉흥형 여행가: 계획보다는 즉흥적으로 여행을 즐깁니다.',
    'c': '자연친화형 여행가: 자연을 가까이에서 즐기길 원합니다.',
    'd': '도시탐험형 여행가: 도시의 문화와 랜드마크를 탐험합니다.',
    'e': '혼합형 여행가: 계획과 즉흥을 조화롭게 섞어 여행을 즐깁니다.',
    'f': '새로운 것 탐험형 여행가: 새로운 것에 대한 호기심으로 여행합니다.',
  };

  @override
  AsyncValue<PreferenceTest?> build() {
    return const AsyncValue.data(null);
  }

  /// AI 분석만 실행
  Future<void> classifyTestOnly(List<Map<String, String>> answersRaw) async {
    state = const AsyncValue.loading();

    try {
      final resultSummary = answersRaw
          .map((a) => '${a['question']} => ${a['selectedOption']}')
          .join(', ');

      final prompt = '''
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
''';

      final typeCode = await _aiService.getTypeCodeFromAI(prompt);
      final description = typeDescriptions[typeCode] ?? '알 수 없는 유형';
      final now = DateTime.now();

      final answers =
          answersRaw
              .map(
                (a) => PreferenceAnswer(
                  questionId: a['questionId']!,
                  selectedOption: a['selectedOption']!,
                ),
              )
              .toList();

      final test = PreferenceTest(
        testId: '',
        userId: '',
        answers: answers,
        result: {'type': typeCode, 'details': description},
        createdAt: now,
        updatedAt: now,
      );

      state = AsyncValue.data(test);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 저장 실행 (AI 분석 이후 상태 기반으로 Firestore 저장)
  Future<void> saveTestToFirestore() async {
    final current = state.value;
    if (current == null) return;

    if (current.testId.isEmpty) {
      // 새로 생성
      final newId = await _service.saveTest(current);
      state = AsyncValue.data(current.copyWith(testId: newId));
    } else {
      // 기존 문서 덮어쓰기
      await _service.saveOrUpdateTest(current);
    }
  }

  /// 단건 로드
  Future<void> loadTest(String testId) async {
    state = const AsyncValue.loading();
    try {
      final test = await _service.fetchTest(testId);
      state = AsyncValue.data(test);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
