import 'package:flutter/material.dart';

Future<void> showAiRouteResultPopup({
  required BuildContext context,
  required String typeCode,
  required Map<int, List<Map<String, String>>> enriched,
}) async {
  final validTypes = ['계획러', '자유인', '자연인', '도시러', '균형러', '모험가'];
  final typeTitle = validTypes.contains(typeCode) ? typeCode : '여행자';

  await showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 10,
          ),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            constraints: const BoxConstraints(maxHeight: 500), // 화면 제한
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
                      '여행 스타일에 어울리는 장소들을 모아\n'
                      '추천드려요!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                  ...enriched.entries.expand((entry) {
                    return entry.value.map(
                      (place) => Padding(
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
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 123,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF48CDFD),
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
