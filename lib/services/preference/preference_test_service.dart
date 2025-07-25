import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/preference/preference_test_model.dart';
import 'package:travel_muse_app/repositories/preference/preference_test_repository.dart';
import 'package:travel_muse_app/services/plan/ai_service.dart';
import 'package:travel_muse_app/utills/logger_util.dart';

class PreferenceTestService {
  final _aiService = AiService();
  final _repo = PreferenceTestRepository();

  final _typeDescriptions = {
    '계획러':
        '철두철미 계획러: 여행도 프로젝트처럼 완벽하게 준비해야 마음이 편한 타입이에요. 일정표, 맛집 리스트, 교통편까지 꼼꼼하게 계획하며 불확실성을 최소화하죠.',
    '자유인':
        '자유로운 방랑자: 즉흥과 자유를 즐기는 여행가예요. 계획보단 흐름에 맡기고, 예상치 못한 순간에 진짜 여행의 즐거움을 느끼죠.',
    '자연인':
        '숲속 힐러: 번잡한 도시보다 조용한 자연에서 진정한 쉼을 찾는 타입이에요. 바다, 산, 숲에서 재충전하는 걸 최고의 여행으로 생각해요.',
    '도시러':
        '도시 정복자: 랜드마크, 쇼핑, 핫플 탐방을 빠짐없이 즐기는 도심형 여행가예요. 트렌디한 장소에서 에너지를 얻고, 도시 특유의 활기를 좋아하죠.',
    '균형러':
        '밸런스 마스터: 계획과 여유, 활동과 휴식 사이에서 완벽한 균형을 추구해요. 효율도 중요하지만, 감정과 순간의 흐름도 놓치지 않으려는 스마트 여행가죠.',
    '모험가':
        '체험형 모험가: 관광보다 체험을 중요하게 여기는 도전형 타입이에요. 액티비티, 현지 문화 체험 등 몸으로 부딪히며 느끼는 여행을 선호하죠.',
  };

  Future<PreferenceTest> classify(
    List<Map<String, String>> answersRaw,
    BuildContext context,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      logger.e('로그인되지 않은 상태에서 테스트 요청');
      throw Exception('로그인되지 않은 상태입니다.');
    }

    // 테스트 제한 체크
    final allowed = await _repo.canTakeTest(user.uid);
    if (!allowed) {
      logger.w('테스트 횟수 초과됨: ${user.uid}');
      CustomToast.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: '성향 테스트는 계정당 최대 50회까지만 가능합니다.',
      );
      throw Exception('테스트 횟수 제한됨');
    }

    // 테스트 횟수 증가
    await _repo.incrementTestCount(user.uid);

    // 응답 파싱
    final answers =
        answersRaw.map((a) {
          return PreferenceAnswer(
            questionId: a['questionId']!,
            selectedOption: a['selectedOption']!,
          );
        }).toList();

    // 해시 생성 및 캐시 체크
    final answersHash = _repo.generateAnswersHash(answers);
    final cached = await _repo.findTestByAnswerHash(user.uid, answersHash);
    if (cached != null) return cached;

    // Gemini 호출
    final resultSummary = answersRaw
        .map((a) => '${a['question']} => ${a['selectedOption']}')
        .join(', ');

    final prompt = '''
아래는 사용자의 여행 성향 테스트 결과입니다.
각 질문에 대해 사용자가 선택한 하나 이상의 보기 항목이 나열되어 있습니다.
선택된 항목들을 분석해 가장 어울리는 여행가 타입을 하나만 골라주세요.

결과는 아래 6가지 중에서 **가장 비중이 높은 성향**을 고려해 판단하고,
**코드만 단독으로 출력**하세요. 추가 설명은 절대 하지 마세요.

사용자 응답:
$resultSummary

선택 가능한 타입 코드:
계획러: 철두철미 계획러
자유인: 자유로운 방랑자
자연인: 숲속 힐러
도시러: 도시 정복자
균형러: 밸런스 마스터
모험가: 체험형 모험가

=> 결과:
''';

    // ignore: use_build_context_synchronously
    final typeCode = await _aiService.getTypeCodeFromAI(prompt, context);

    if (!_typeDescriptions.containsKey(typeCode)) {
      logger.w('알 수 없는 typeCode 반환됨: $typeCode');
    }

    final description = _typeDescriptions[typeCode] ?? '알 수 없는 유형';
    final now = DateTime.now();

    final test = PreferenceTest(
      testId: '',
      userId: user.uid,
      answers: answers,
      result: {'type': typeCode, 'details': description},
      createdAt: now,
      updatedAt: now,
      answersHash: answersHash,
    );

    // 저장 (해시 포함)
    final newId = await _repo.saveTestWithHash(test, answersHash);
    return test.copyWith(testId: newId);
  }
}
