import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';
import 'package:travel_muse_app/services/ai_service.dart';
import 'package:travel_muse_app/services/preference_test_service.dart';

class PreferenceTestRepository {
  final _aiService = AiService();
  final _service = PreferenceTestService();

  final Map<String, String> _typeDescriptions = {
    'a': '계획형 여행가: 여행을 철저하게 계획하고 준비하는 성향입니다.',
    'b': '즉흥형 여행가: 계획보다는 즉흥적으로 여행을 즐깁니다.',
    'c': '자연친화형 여행가: 자연을 가까이에서 즐기길 원합니다.',
    'd': '도시탐험형 여행가: 도시의 문화와 랜드마크를 탐험합니다.',
    'e': '혼합형 여행가: 계획과 즉흥을 조화롭게 섞어 여행을 즐깁니다.',
    'f': '새로운 것 탐험형 여행가: 새로운 것에 대한 호기심으로 여행합니다.',
  };

  Future<PreferenceTest> classifyTestOnly(
    List<Map<String, String>> answersRaw,
  ) async {
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
      userId: '',
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
