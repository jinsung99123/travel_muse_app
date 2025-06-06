import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';
import 'package:travel_muse_app/services/ai_service.dart';

class PreferenceTestRepository {
  final _aiService = AiService();

  final Map<String, String> _typeDescriptions = {
    'planner': '철두철미 계획러: 여행은 미리미리! 엑셀표까지 만들어야 마음이 놓이죠.',
    'free_spirit': '자유로운 방랑자: 즉흥 여행이 진짜 여행! 발 닿는 대로 떠나요.',
    'nature_lover': '숲속 힐러: 사람보다 나무가 좋을 때, 자연 속 쉼이 최고의 여정입니다.',
    'city_explorer': '도시 정복자: 랜드마크와 핫플 투어는 빠짐없이, 감각적인 여행을 즐깁니다.',
    'balanced_traveler': '밸런스 마스터: 일정은 짜되, 여유도 챙기는 여행 스타일의 고수입니다.',
    'experience_seeker': '체험형 모험가: 먹어보고, 타보고, 느껴보며 오감으로 기억하는 여행러!',
  };

  Future<PreferenceTest> classifyTestOnly(
    List<Map<String, String>> answersRaw,
  ) async {
    /*TODO:개발단계 끝나면 주석 제거
    final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    throw Exception('로그인되지 않은 상태에서는 테스트를 저장할 수 없습니다.');
  }*/

    final resultSummary = answersRaw
        .map((a) => '${a['question']} => ${a['selectedOption']}')
        .join(', ');
    final prompt = '''
사용자의 여행 성향 테스트 결과:
$resultSummary

아래 중에서 가장 적합한 하나의 여행가 타입 코드 하나만 골라서 반환해줘.
반드시 아래 중 하나로만 대답해. 추가 설명은 하지 말고, 코드만 반환해.

planner: 철두철미 계획러
free_spirit: 자유로운 방랑자
nature_lover: 숲속 힐러
city_explorer: 도시 정복자
balanced_traveler: 밸런스 마스터
experience_seeker: 체험형 모험가
''';

    final typeCode = await _aiService.getTypeCodeFromAI(prompt);
    final description = _typeDescriptions[typeCode] ?? '알 수 없는 유형';
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

    return PreferenceTest(
      testId: '',
      userId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
      answers: answers,
      result: {'type': typeCode, 'details': description},
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<PreferenceTest> saveOrUpdateTest(PreferenceTest test) async {
    if (test.testId.isEmpty) {
      final newId = await saveTest(test);
      return test.copyWith(testId: newId);
    } else {
      await saveOrUpdateTest(test);
      return test;
    }
  }

  Future<PreferenceTest> loadTest(String testId) async {
    return await fetchTest(testId);
  }

  final _firestore = FirebaseFirestore.instance;
  final _collection = 'preference_test';

  /// Firestore에 테스트 저장
  Future<String> saveTest(PreferenceTest test) async {
    final docRef = _firestore.collection(_collection).doc();
    final data = test.copyWith(testId: docRef.id).toMap();
    await docRef.set(data);
    return docRef.id;
  }

  /// Firestore에서 테스트 불러오기 (단건)
  Future<PreferenceTest> fetchTest(String testId) async {
    final doc = await _firestore.collection(_collection).doc(testId).get();
    return PreferenceTest.fromDoc(doc.id, doc.data()!);
  }

  Stream<PreferenceTest> watchTest(String testId) {
    return _firestore.collection(_collection).doc(testId).snapshots().map((
      doc,
    ) {
      final data = doc.data();
      if (data == null) throw Exception('문서가 존재하지 않음');
      return PreferenceTest.fromDoc(doc.id, data);
    });
  }
}
