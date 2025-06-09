import 'package:flutter/material.dart';

class PlanPlaceCard extends StatelessWidget {
  const PlanPlaceCard({
    super.key,
    required this.place,
    this.selected = false, // 선택 여부 기본값 false
  });

  final Map<String, String> place;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final imageUrl = place['image'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(
            color: selected ? Colors.blue : Colors.transparent, // 선택 시 파란 테두리
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(158, 158, 158, 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              // 왼쪽 이미지
              imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                    ),
              const SizedBox(width: 12),
              // 텍스트 + 체크 아이콘
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            place['subtitle'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle, color: Colors.blue), // 체크 표시
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
