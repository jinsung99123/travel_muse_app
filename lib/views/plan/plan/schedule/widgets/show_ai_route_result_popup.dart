import 'package:flutter/material.dart';

/// AI 분석 결과를 기반으로 장소 리스트를 팝업으로 보여주는 함수
/// - [typeCode]: 여행 성향 코드
/// - [enriched]: 일자별 추천 장소 맵
Future<void> showAiRouteResultPopup({
  required BuildContext context,
  required String typeCode,
  required Map<int, List<Map<String, String>>> enriched,
}) async {
  final validTypes = ['계획러', '자유인', '자연인', '도시러', '균형러', '모험가'];
  final typeTitle = validTypes.contains(typeCode) ? typeCode : '여행자';

  // 모든 추천 데이터가 비어 있는 경우 예외 처리
  final allEmpty =
      enriched.isEmpty || enriched.values.every((dayList) => dayList.isEmpty);

  if (allEmpty) {
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('추천 결과 없음'),
            content: const Text('추천할 장소가 없습니다. 다른 조건으로 다시 시도해 보세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
    return;
  }

  // 추천 데이터가 있는 경우 팝업 보여주기
  await showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 10,
          ),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '🤖 AI가 분석한 $typeTitle 여행자님 맞춤 일정입니다.\n\n'
                      '여행 스타일에 어울리는 장소들을 모아\n추천드려요!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                  ...enriched.entries.expand((entry) {
                    return entry.value.map((place) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: '${place['title'] ?? '제목 없음'}\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                  height: 1.4,
                                ),
                              ),
                              TextSpan(
                                text: place['description'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                    // ignore: unnecessary_to_list_in_spreads
                  }).toList(),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 123,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF48CDFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Pretendard',
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
