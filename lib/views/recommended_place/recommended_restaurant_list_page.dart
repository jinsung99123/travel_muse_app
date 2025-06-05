import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/recommended_place/widgets/recommended_restaurant_list_card.dart';

class RecommendedRestaurantsListPage extends StatelessWidget {
  const RecommendedRestaurantsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF03A9F4);

    final List<_RestaurantData> restaurants = [
      _RestaurantData(
        name: '핫도그 두물머리점',
        image: 'assets/images/image3.png',
        description: '두물머리 명물 수제 핫도그',
        isActive: true,
      ),
      _RestaurantData(
        name: '준비 중',
        image: '',
        description: '곧 추가될 맛집',
        isActive: false,
      ),
      _RestaurantData(
        name: '준비 중',
        image: '',
        description: '곧 추가될 맛집',
        isActive: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 맛집 전체 보기'),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return RecommendedRestaurantListCard(
            name: restaurant.name,
            image: restaurant.image,
            description: restaurant.description,
            isActive: restaurant.isActive,
          );
        },
      ),
    );
  }
}

class _RestaurantData {
  _RestaurantData({
    required this.name,
    required this.image,
    required this.description,
    required this.isActive,
  });

  final String name;
  final String image;
  final String description;
  final bool isActive;
}
