import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/recommended_place/recommended_place_detail_page.dart';

class RecommendedPlacesListPage extends StatelessWidget {
  const RecommendedPlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF03A9F4);

    final List<_PlaceData> places = [
      _PlaceData(
        title: '두물머리',
        image: 'assets/images/image1.png',
        description: '물안개가 아름다운 감성 명소',
        isActive: true,
      ),
      _PlaceData(
        title: '준비 중',
        image: '',
        description: '곧 추가될 명소',
        isActive: false,
      ),
      _PlaceData(
        title: '준비 중',
        image: '',
        description: '곧 추가될 명소',
        isActive: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 명소 전체 보기'),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: places.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final place = places[index];

          return GestureDetector(
            onTap:
                place.isActive
                    ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecommendedPlaceDetailPage(),
                        ),
                      );
                    }
                    : null,
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                    child:
                        place.image.isNotEmpty
                            ? Image.asset(
                              place.image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            place.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlaceData {
  final String title;
  final String image;
  final String description;
  final bool isActive;

  _PlaceData({
    required this.title,
    required this.image,
    required this.description,
    required this.isActive,
  });
}
