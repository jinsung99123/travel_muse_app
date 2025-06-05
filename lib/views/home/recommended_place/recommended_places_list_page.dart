import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/home/recommended_place/widgets/recommended_place_list_card.dart';

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
          return RecommendedPlaceListCard(
            title: place.title,
            image: place.image,
            description: place.description,
            isActive: place.isActive,
          );
        },
      ),
    );
  }
}

class _PlaceData {
  _PlaceData({
    required this.title,
    required this.image,
    required this.description,
    required this.isActive,
  });

  final String title;
  final String image;
  final String description;
  final bool isActive;
}
