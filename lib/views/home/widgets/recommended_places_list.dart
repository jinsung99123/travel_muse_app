import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_places_list_page.dart';

class RecommendedPlacesList extends StatelessWidget {
  const RecommendedPlacesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> hashtags = ['#힐링', '#유적지', '#쇼핑', '#가족과 함께'];

    final List<_PlaceCardData> places = [
      _PlaceCardData(
        title: '부산, 광안리',
        imageAssetPath: 'assets/images/image14.png',
      ),
      _PlaceCardData(
        title: '제주, 사려니숲길',
        imageAssetPath: 'assets/images/image15.png',
      ),
      _PlaceCardData(
        title: '하동, 섬진강변',
        imageAssetPath: 'assets/images/image17.png',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  hashtags.map((tag) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF48CDFD)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFF15BFFD),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: places.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final place = places[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecommendedPlaceDetailPage(),
                    ),
                  );
                },
                child: SizedBox(
                  width: 118,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 118,
                          height: 139,
                          child: AspectRatio(
                            aspectRatio: 118 / 139,
                            child: Image.asset(
                              place.imageAssetPath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        place.title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecommendedPlacesListPage(),
                  ),
                );
              },
              child: const Text(
                '더보기 >',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF48CDFD),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceCardData {
  _PlaceCardData({required this.title, required this.imageAssetPath});
  final String title;
  final String imageAssetPath;
}
