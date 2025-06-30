import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/preference/preference_test_model.dart';
import 'package:travel_muse_app/repositories/preference/preference_test_repository.dart';
import 'package:travel_muse_app/services/plan/ai_service.dart';

class PreferenceTestService {
  final _aiService = AiService();
  final _repo = PreferenceTestRepository();

  final _typeDescriptions = {
    '계획러': '철두철미 계획러: 여행은 미리미리! 엑셀표까지 만들어야 마음이 놓이죠.',
    '자유인': '자유로운 방랑자: 즉흥 여행이 진짜 여행!',
    '자연인': '숲속 힐러: 사람보다 나무가 좋을 때!',
    '도시러': '도시 정복자: 랜드마크와 핫플 투어는 기본!',
    '균형러': '밸런스 마스터: 일정도, 여유도 모두 챙기는!',
    '모험가': '체험형 모험가: 오감으로 기억하는 여행!',
  };

  Future<PreferenceTest> classify(
    List<Map<String, String>> answersRaw,
    BuildContext context,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('로그인되지 않은 상태입니다.');
    }
    // 테스트 제한 체크
    final allowed = await _repo.canTakeTest(user.uid);
    if (!allowed) {
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
사용자의 여행 성향 테스트 결과:
$resultSummary

아래 중에서 가장 적합한 하나의 여행가 타입 코드 하나만 골라서 반환해줘.
반드시 아래 중 하나로만 대답해. 추가 설명은 하지 말고, 코드만 반환해.

계획러: 철두철미 계획러
자유인: 자유로운 방랑자
자연인: 숲속 힐러
도시러: 도시 정복자
균형러: 밸런스 마스터
모험가: 체험형 모험가
''';

    // ignore: use_build_context_synchronously
    final typeCode = await _aiService.getTypeCodeFromAI(prompt, context);
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
